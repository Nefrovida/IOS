import SwiftUI
import Combine

@MainActor
class ForumViewModel: ObservableObject {
    // Observable state for the viewField
    @Published var messages: [ForumMessageEntity] = []
    @Published var newMessageContent: String = ""
    @Published var replyContent: String = ""
    @Published var selectedParentMessageId: Int? = nil
    @Published var forum: Forum?
    @Published var isLoading = false
    @Published var errorMessage: String?

    // Dependencias (casos de uso)
    private let getMessagesUC: GetMessagesUseCase
    private let postMessageUC: PostMessageUseCase
    private let replyToMessageUC: ReplyToMessageUseCase
    private let getForumDetailsUC: GetForumDetailsUseCase
    private let getRepliesUC: GetRepliesUseCase

    // Dependencies (use cases)
    init(getMessagesUC: GetMessagesUseCase,
         postMessageUC: PostMessageUseCase,
         replyToMessageUC: ReplyToMessageUseCase,
         getForumDetailsUC: GetForumDetailsUseCase,
         getRepliesUC: GetRepliesUseCase) {
        self.getMessagesUC = getMessagesUC
        self.postMessageUC = postMessageUC
        self.replyToMessageUC = replyToMessageUC
        self.getForumDetailsUC = getForumDetailsUC
        self.getRepliesUC = getRepliesUC
    }

    // MARK: - Funciones de negocio

    // Load all messages from a forum
    func loadMessages(forumId: Int) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            // Fetch forum details and messages in parallel
            async let fetchedMessages = getMessagesUC.execute(forumId: forumId)
            async let (fetchedForum, _) = getForumDetailsUC.execute(forumId: forumId)
            
            self.messages = try await fetchedMessages
            self.forum = try await fetchedForum
        } catch {
            self.errorMessage = "No se pudo cargar el foro."
        }
    }
    
    // Send a new root message
    func sendMessage(forumId: Int) async {
        guard !newMessageContent.isEmpty else { return }
        do {
            let message = try await postMessageUC.execute(forumId: forumId, content: newMessageContent)
            messages.append(message)
            newMessageContent = ""
        } catch {
            print("❌ Error sending message: \(error)")
            // Fallback: reload messages if local append failed (e.g. decoding error)
            // If we are reloading, it implies we assume the message might have been sent.
            // Clear the text box so the user doesn't send it again.
            newMessageContent = ""
            await loadMessages(forumId: forumId)
        }
    }

    // Reply to an existing message
    func sendReply(forumId: Int) async {
        guard let parentId = selectedParentMessageId, !replyContent.isEmpty else { return }
        do {
            let reply = try await replyToMessageUC.execute(
                forumId: forumId,
                parentMessageId: parentId,
                content: replyContent
            )
            messages.append(reply)
            replyContent = ""
            selectedParentMessageId = nil
        } catch {
        }
    }
    
    // Fetch replies for a specific message
    func fetchReplies(forumId: Int, messageId: Int) async {
        do {
            let replies = try await getRepliesUC.execute(forumId: forumId, messageId: messageId, page: 1, limit: 20)
            // Append new replies, avoiding duplicates
            let existingIds = Set(messages.map { $0.id })
            let newReplies = replies.filter { !existingIds.contains($0.id) }
            messages.append(contentsOf: newReplies)
        } catch {
            print("Error fetching replies: \(error)")
        }
    }
}
