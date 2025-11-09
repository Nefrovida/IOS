//  AnalisisViewModel.swift
//  NefrovidaApp
//
//  Created by Enrique Ayala on 08/11/25.
//
//  ViewModel managing Analisis list loading and deletion workflow.
//  Implements MVVM with published properties for SwiftUI state updates.

import Foundation
import Combine

@MainActor
final class AnalisisViewModel: ObservableObject {
    // MARK: - Published State
    @Published var analisis: [Analisis] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showDeleteConfirmation: Bool = false
    @Published var showSuccessMessage: Bool = false
    @Published var selectedAnalisis: Analisis?

    // MARK: - Dependencies
    private let obtenerAnalisisUseCase: ObtenerAnalisisUseCaseProtocol
    private let eliminarAnalisisUseCase: EliminarAnalisisUseCaseProtocol

    // MARK: - Init
    init(obtenerAnalisisUseCase: ObtenerAnalisisUseCaseProtocol,
         eliminarAnalisisUseCase: EliminarAnalisisUseCaseProtocol) {
        self.obtenerAnalisisUseCase = obtenerAnalisisUseCase
        self.eliminarAnalisisUseCase = eliminarAnalisisUseCase
    }

    /// Factory for production/live dependencies.
    static func live() -> AnalisisViewModel {
        let service = AnalisisService()
        return AnalisisViewModel(
            obtenerAnalisisUseCase: ObtenerAnalisisUseCase(service: service),
            eliminarAnalisisUseCase: EliminarAnalisisUseCase(service: service)
        )
    }

    /// Factory that accepts an explicit service (useful for previews or alternative stacks).
    static func live(service: AnalisisServiceProtocol) -> AnalisisViewModel {
        AnalisisViewModel(
            obtenerAnalisisUseCase: ObtenerAnalisisUseCase(service: service),
            eliminarAnalisisUseCase: EliminarAnalisisUseCase(service: service)
        )
    }

    // MARK: - Intent / User Actions

    /// Called when the Analisis screen appears; loads current list.
    func onAnalisisScreenLoaded() {
        Task { await loadAnalisis() }
    }

    /// Called when user taps the options/settings icon for an analysis.
    /// - Parameter idAnalisis: Identifier of selected analysis.
    func onEliminarAnalisisClicked(idAnalisis: String) {
        guard let target = analisis.first(where: { $0.id == idAnalisis }) else { return }
        selectedAnalisis = target
        showDeleteConfirmation = true
    }

    /// Called when user confirms deletion.
    /// - Parameter idAnalisis: Identifier to delete; falls back to `selectedAnalisis`.
    func onConfirmarEliminacion(idAnalisis: String) {
        Task { await deleteAnalisis(id: idAnalisis) }
    }

    /// Dismisses any currently visible dialogs.
    func dismissDialogs() {
        showDeleteConfirmation = false
        showSuccessMessage = false
    }

    // MARK: - Private Workflows

    private func loadAnalisis() async {
        isLoading = true
        errorMessage = nil
        do {
            let items = try await obtenerAnalisisUseCase.execute()
            analisis = items
        } catch {
            errorMessage = localizedError(for: error)
        }
        isLoading = false
    }

    private func deleteAnalisis(id: String) async {
        isLoading = true
        errorMessage = nil
        do {
            try await eliminarAnalisisUseCase.execute(id: id)
            // Remove locally.
            analisis.removeAll { $0.id == id }
            // Show success.
            showDeleteConfirmation = false
            showSuccessMessage = true
        } catch {
            errorMessage = localizedError(for: error)
            showDeleteConfirmation = false
        }
        isLoading = false
    }

    // MARK: - Error Localization

    private func localizedError(for error: Error) -> String {
        if let networkError = error as? NetworkError, let description = networkError.errorDescription {
            return description
        }
        return NSLocalizedString("error_generic", comment: "Generic error message")
    }
}
