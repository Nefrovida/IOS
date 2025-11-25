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

    // Dependencies (use cases)
    init(getMessagesUC: GetMessagesUseCase,
         postMessageUC: PostMessageUseCase,
         replyToMessageUC: ReplyToMessageUseCase,
         getForumDetailsUC: GetForumDetailsUseCase) {
        self.getMessagesUC = getMessagesUC
        self.postMessageUC = postMessageUC
        self.replyToMessageUC = replyToMessageUC
        self.getForumDetailsUC = getForumDetailsUC
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
}
