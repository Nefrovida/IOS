//
//  ForumViewModel.swift
//  NefrovidaApp
//

import SwiftUI
import Combine

extension Notification.Name {
    static let forumRepliesUpdated = Notification.Name("forumRepliesUpdated")
}

@MainActor
class ForumViewModel: ObservableObject {
    @Published var messages: [ForumMessageEntity] = []
    @Published var replyContent: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let replyToMessageUC: ReplyToMessageUseCase
    private let getRepliesUC: GetRepliesUseCase

    init(
        replyToMessageUC: ReplyToMessageUseCase,
        getRepliesUC: GetRepliesUseCase
    ) {
        self.replyToMessageUC = replyToMessageUC
        self.getRepliesUC = getRepliesUC
    }

    // ======== VALIDACIÓN ========
    var isValidReply: Bool {
        !replyContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && replyContent.count <= 1000
    }

    var characterCountColor: Color {
        if replyContent.count > 700 {
            return .red
        } else if replyContent.count > 650 {
            return .orange
        } else {
            return .gray
        }
    }

    // ======== LOAD THREAD ========
    func loadThread(forumId: Int, rootId: Int) async {
        isLoading = true
        defer { isLoading = false }

        do {
            messages = try await getRepliesUC.execute(
                forumId: forumId,
                messageId: rootId,
                page: 1,
                limit: 20
            )
        } catch {
            errorMessage = "No se pudieron cargar las respuestas."
        }
    }

    // ======== SEND REPLY ========
    func sendReply(forumId: Int, rootId: Int) async {
        // Seguridad: evitar bypass
        guard isValidReply else { return }

        do {
            let newReply = try await replyToMessageUC.execute(
                forumId: forumId,
                parentMessageId: rootId,
                content: replyContent
            )

            messages.append(newReply)
            replyContent = ""

            NotificationCenter.default.post(
                name: .forumRepliesUpdated,
                object: nil,
                userInfo: ["messageId": rootId]
            )
            
        } catch {
            print("❌ Error enviando reply: \(error)")
            errorMessage = "No se pudo enviar la respuesta."
        }
    }
}
