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
    @Published var messages: [ForumMessage] = []
    @Published var isLoading: Bool = false
    @Published var isRefreshing: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    @Published var selectedFilter: String = "Popular"
    @Published var hasMore: Bool = true
    
    private let repository: ForumRepository
    private var currentPage: Int = 1
    
    init(repository: ForumRepository = ForumRepository()) {
        self.repository = repository
    }
    
    // MARK: - Load Initial Feed
    func loadFeed() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        currentPage = 1
        
        do {
            let response = try await repository.getMessagesFeed(page: currentPage, limit: 20)
            messages = response.messages
            hasMore = response.hasMore
        } catch let error as NetworkError {
            setError(getNetworkErrorMessage(error))
        } catch {
            setError("Error inesperado al cargar los mensajes")
        }
        
        isLoading = false
    }
    
    // MARK: - Refresh Feed
    func refreshFeed() async {
        guard !isRefreshing else { return }
        
        isRefreshing = true
        errorMessage = nil
        currentPage = 1
        
        do {
            let response = try await repository.getMessagesFeed(page: currentPage, limit: 20)
            messages = response.messages
            hasMore = response.hasMore
        } catch let error as NetworkError {
            setError(getNetworkErrorMessage(error))
        } catch {
            setError("Error al refrescar los mensajes")
        }
        
        isRefreshing = false
    }
    
    // MARK: - Load More (Pagination)
    func loadMore() async {
        guard hasMore && !isLoading else { return }
        
        isLoading = true
        currentPage += 1
        
        do {
            let response = try await repository.getMessagesFeed(page: currentPage, limit: 20)
            messages.append(contentsOf: response.messages)
            hasMore = response.hasMore
        } catch {
            // Si falla, revertimos el incremento de página
            currentPage -= 1
        }
        
        isLoading = false
    }
    
    // MARK: - Actions (Placeholder - no hacen nada por ahora)
    func toggleLike(for message: ForumMessage) {
        // TODO: Implementar like/unlike
        print("Like toggled for message: \(message.id)")
    }
    
    func openComments(for message: ForumMessage) {
        // TODO: Navegar a comentarios
        print("Open comments for message: \(message.id)")
    }
    
    func showMoreOptions(for message: ForumMessage) {
        // TODO: Mostrar menú de opciones
        print("Show options for message: \(message.id)")
    }
    
    // MARK: - Private Helpers
    private func setError(_ message: String) {
        errorMessage = message
        showError = true
    }
    
    private func getNetworkErrorMessage(_ error: NetworkError) -> String {
        switch error {
        case .invalidURL:
            return "URL inválida"
        case .invalidResponse:
            return "Respuesta inválida del servidor"
        case .unauthorized:
            return "No autorizado. Por favor inicia sesión nuevamente"
        case .serverError(let message):
            return "Error del servidor: \(message)"
        case .decodingError:
            return "Error al procesar la respuesta"
        case .unknown:
            return "Error desconocido"
        }
    }
}
