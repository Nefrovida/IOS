//
//  FeedViewModel.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 23/11/25.
//
import SwiftUI
import Combine
import Observation

@MainActor
final class FeedViewModel: ObservableObject {
    @Published var items: [ForumFeedItem] = []
    @Published var page = 0
    @Published var isLoading = false
    
    private let repo: ForumRepository

    public let forumId: Int
    public let forumName: String

    init(repo: ForumRepository, forumId: Int, forumName: String) {
        self.repo = repo
        self.forumId = forumId
        self.forumName = forumName
    }
    
    func loadNext() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            let new = try await repo.getFeed(forumId: forumId, page: page)
            items.append(contentsOf: new)
            page += 1
        } catch {
            print("Error loading feed:", error)
        }
    }
}
