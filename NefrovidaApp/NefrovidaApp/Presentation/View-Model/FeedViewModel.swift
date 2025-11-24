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
    private let forumId: Int?

    init(repo: ForumRepository, forumId: Int?) {
        self.repo = repo
        self.forumId = forumId
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
