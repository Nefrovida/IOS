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
    @Published var replyingTo: ForumMessageEntity?

    private let replyToMessageUC: ReplyToMessageUseCase
    private let getRepliesUC: GetRepliesUseCase
    private let repo: ForumRepository

    init(
        replyToMessageUC: ReplyToMessageUseCase,
        getRepliesUC: GetRepliesUseCase,
        repo: ForumRepository
    ) {
        self.replyToMessageUC = replyToMessageUC
        self.getRepliesUC = getRepliesUC
        self.repo = repo
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
            var allMessages: [ForumMessageEntity] = []
            let rootReplies = try await getRepliesUC.execute(
                forumId: forumId,
                messageId: rootId,
                page: 1,
                limit: 20
            )

            allMessages.append(contentsOf: rootReplies)

            var queue: [ForumMessageEntity] = rootReplies

            while !queue.isEmpty {
                let current = queue.removeFirst()

                guard current.repliesCount > 0 else { continue }

                let children = try await getRepliesUC.execute(
                    forumId: forumId,
                    messageId: current.id,
                    page: 1,
                    limit: 20
                )

                allMessages.append(contentsOf: children)
                queue.append(contentsOf: children)
            }

            var seen = Set<Int>()
            let unique = allMessages.filter { msg in
                if seen.contains(msg.id) { return false }
                seen.insert(msg.id)
                return true
            }

            messages = unique.sorted { lhs, rhs in
                if let lDateStr = lhs.createdAt,
                   let rDateStr = rhs.createdAt,
                   let lDate = ISO8601DateFormatter().date(from: lDateStr),
                   let rDate = ISO8601DateFormatter().date(from: rDateStr) {
                    return lDate < rDate
                } else {
                    return lhs.id < rhs.id
                }
            }

        } catch {
            print("Error cargando hilo:", error)
            errorMessage = "No se pudieron cargar las respuestas."
            messages = []
        }
    }

    // ======== SEND REPLY ========
    func sendReply(forumId: Int, rootId: Int) async {
        guard isValidReply else { return }

        let parentId = replyingTo?.id ?? rootId

        do {
            let newReply = try await replyToMessageUC.execute(
                forumId: forumId,
                parentMessageId: parentId,
                content: replyContent
            )

            messages.append(newReply)
            replyContent = ""
            replyingTo = nil

            if parentId == rootId {
                NotificationCenter.default.post(
                    name: .forumRepliesUpdated,
                    object: nil,
                    userInfo: ["messageId": rootId]
                )
            } else {
                if let idx = messages.firstIndex(where: { $0.id == parentId }) {
                    messages[idx].repliesCount += 1
                }
            }
        } catch {
            print("❌ Error enviando reply:", error)
            errorMessage = "No se pudo enviar la respuesta."
        }
    }
    
    // ======== LIKES ========
    func toggleLike(for messageId: Int) async {
        guard let index = messages.firstIndex(where: { $0.id == messageId }) else { return }

        var item = messages[index]
        let wasLiked = item.liked
        let oldLikes = item.likesCount

        item.liked.toggle()
        item.likesCount += item.liked ? 1 : -1
        messages[index] = item

        do {
            try await repo.toggleLike(messageId: messageId)
        } catch {
            var reverted = messages[index]
            reverted.liked = wasLiked
            reverted.likesCount = oldLikes
            messages[index] = reverted
            print("❌ Error al hacer like en hilo:", error)
        }
    }
}
