//
//  ForumFeedViewModel.swift
//  NefrovidaApp
//
//  Created by Armando Fuentes Silva on 17/11/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class ForumFeedViewModel: ObservableObject {
    @Published var messages: [ForumMessageEntity] = []
    @Published var isLoading: Bool = false
    @Published var isRefreshing: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    @Published var selectedFilter: String = "Popular"
    @Published var hasMore: Bool = false
    
    private let repository = ForumRemoteRepository(baseURL: AppConfig.apiBaseURL, tokenProvider: AppConfig.tokenProvider)
    private let forumId = 1
    
    init() {
        Task {
            await loadFeed()
        }
    }
    
    // MARK: - Load Initial Feed
    func loadFeed() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            messages = try await repository.getMessages(forumId: forumId)
        } catch {
            setError("Error al cargar los mensajes: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    // MARK: - Refresh Feed
    func refreshFeed() async {
        guard !isRefreshing else { return }
        
        isRefreshing = true
        errorMessage = nil
        
        do {
            messages = try await repository.getMessages(forumId: forumId)
        } catch {
            setError("Error al refrescar los mensajes: \(error.localizedDescription)")
        }
        
        isRefreshing = false
    }
    
    // MARK: - Load More (no implementado - el backend no tiene paginación aún)
    func loadMore() async {
        // Por ahora no hace nada, no hay paginación en el backend
    }
    
    // MARK: - Actions (Placeholder)
    func toggleLike(for message: ForumMessageEntity) {
        print("Like toggled for message: \(message.id)")
    }
    
    func openComments(for message: ForumMessageEntity) {
        print("Open comments for message: \(message.id)")
    }
    
    func showMoreOptions(for message: ForumMessageEntity) {
        print("Show options for message: \(message.id)")
    }
    
    // MARK: - Private Helpers
    private func setError(_ message: String) {
        errorMessage = message
        showError = true
    }
}
