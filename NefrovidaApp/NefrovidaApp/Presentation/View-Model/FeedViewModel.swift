//
//  FeedViewModel.swift
//  NefrovidaApp
//

import SwiftUI
import Combine
import Observation

@MainActor
final class FeedViewModel: ObservableObject {
    @Published var items: [ForumFeedItem] = []
    @Published var page: Int = 0
    @Published var isLoading: Bool = false
    @Published var reachedEnd: Bool = false

    private let repo: ForumRepository

    public let forumId: Int
    public let forumName: String

    init(repo: ForumRepository, forumId: Int, forumName: String) {
        self.repo = repo
        self.forumId = forumId
        self.forumName = forumName

        NotificationCenter.default.addObserver(
            forName: .forumRepliesUpdated,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard
                let self,
                let messageId = notification.userInfo?["messageId"] as? Int,
                let index = self.items.firstIndex(where: { $0.id == messageId })
            else { return }

            self.items[index].replies += 1
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func loadNext() async {
        guard !isLoading, !reachedEnd else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            let new = try await repo.getFeed(forumId: forumId, page: page)

            if new.isEmpty {
                reachedEnd = true
                return
            }

            items.append(contentsOf: new)
            page += 1
        } catch {
            #if DEBUG
            print("Error loading feed:", error)
            #endif
        }
    }

    /// reset para refresh manual
    func reset() {
        items.removeAll()
        page = 0
        reachedEnd = false
    }

    // MARK: - Likes

    func toggleLike(for messageId: Int) async {
        guard let index = items.firstIndex(where: { $0.id == messageId }) else { return }

        var item = items[index]
        let wasLiked = item.liked

        item.liked.toggle()
        item.likes += item.liked ? 1 : -1
        items[index] = item

        do {
            try await repo.toggleLike(messageId: messageId)
        } catch {
            var reverted = items[index]
            reverted.liked = wasLiked
            reverted.likes += wasLiked ? 1 : -1
            items[index] = reverted

            #if DEBUG
            print("❌ Error al hacer like/dislike:", error)
            #endif
        }
    }
}
