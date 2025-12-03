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
            print("Error loading feed:", error)
        }
    }

    /// reset para refresh manual
    func reset() {
        items.removeAll()
        page = 0
        reachedEnd = false
    }
}
