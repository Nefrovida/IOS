import SwiftUI
import Combine

@MainActor
class ForumViewModel: ObservableObject {
    // Observable state for the viewField
    @Published var messages: [ForumMessageEntity] = []
    @Published var newMessageContent: String = ""
    @Published var replyContent: String = ""
    @Published var selectedParentMessageId: Int? = nil

    // Dependencias (casos de uso)
    private let getMessagesUC: GetMessagesUseCase
    private let postMessageUC: PostMessageUseCase
    private let replyToMessageUC: ReplyToMessageUseCase

    // Dependencies (use cases)
    init(getMessagesUC: GetMessagesUseCase,
         postMessageUC: PostMessageUseCase,
         replyToMessageUC: ReplyToMessageUseCase) {
        self.getMessagesUC = getMessagesUC
        self.postMessageUC = postMessageUC
        self.replyToMessageUC = replyToMessageUC
    }

    // MARK: - Funciones de negocio

    // Load all messages from a forum
    func loadMessages(forumId: Int) async {
        do {
            // messages = try await getMessagesUC.execute(forumId: forumId)
            messages = getMockData()

        } catch {
            print("Error al cargar mensajes: \(error)")
        }
    }

    func getMockData() -> [ForumMessageEntity] {
        return [ForumMessageEntity(
            id: 1,
            forumId: 1,
            parentMessageId: nil,
            content: "hola q hace",
            createdBy: "Pao",
            createdAt: "2025-11-12",),
                ForumMessageEntity(
                    id: 2,
                    forumId: 1,
                    parentMessageId: nil,
                    content: "hola q hace",
                    createdBy: "Pao",
                    createdAt: "2025-11-12",),
                ForumMessageEntity(
                        id: 3,
                        forumId: 1,
                        parentMessageId: nil,
                        content: "hola q hace",
                        createdBy: "Pao",
                        createdAt: "2025-11-12",),
        ForumMessageEntity(
                id: 4,
                forumId: 1,
                parentMessageId: 3,
                content: "hola q hace",
                createdBy: "Pao",
                createdAt: "2025-11-12",)]
    }
    
    // Send a new root message
    func sendMessage(forumId: Int) async {
        guard !newMessageContent.isEmpty else { return }
        do {
            let message = try await postMessageUC.execute(forumId: forumId, content: newMessageContent)
            messages.append(message)
            newMessageContent = ""
        } catch {
            print("Error al enviar mensaje: \(error)")
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
            print("Error al enviar respuesta: \(error)")
        }
    }
}
