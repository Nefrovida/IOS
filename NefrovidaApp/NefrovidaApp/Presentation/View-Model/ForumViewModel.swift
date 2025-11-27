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
    func loadMessages(forumId: Int, rootId: Int) async {
        do {
            self.messages = try await getRepliesUC.execute(
                forumId: forumId,
                messageId: rootId,
                page: 1,
                limit: 20
            )
        } catch {
            print(error)
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
