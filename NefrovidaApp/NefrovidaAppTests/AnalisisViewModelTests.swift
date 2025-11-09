//  AnalisisViewModelTests.swift
//  NefrovidaAppTests
//
//  Created by Enrique Ayala on 08/11/25.
//
//  Swift Testing tests for AnalisisViewModel (no XCTest dependency).

import Testing
@testable import NefrovidaApp

struct AnalisisViewModelTests {
    // MARK: - Test Doubles

    struct ServiceStub: AnalisisServiceProtocol {
        var fetchResult: Result<[Analisis], Error>
        var deleteResult: Result<Void, Error>

        func fetchAnalisis() async throws -> [Analisis] {
            try fetchResult.get()
        }
        func deleteAnalisis(id: String) async throws {
            _ = try deleteResult.get()
        }
    }

    struct ObtenerStub: ObtenerAnalisisUseCaseProtocol {
        let service: AnalisisServiceProtocol
        func execute() async throws -> [Analisis] { try await service.fetchAnalisis() }
    }

    struct EliminarStub: EliminarAnalisisUseCaseProtocol {
        let service: AnalisisServiceProtocol
        func execute(id: String) async throws { try await service.deleteAnalisis(id: id) }
    }

    @MainActor
    private func makeViewModel(fetch: Result<[Analisis], Error>, delete: Result<Void, Error>) -> AnalisisViewModel {
        let service = ServiceStub(fetchResult: fetch, deleteResult: delete)
        return AnalisisViewModel(
            obtenerAnalisisUseCase: ObtenerStub(service: service),
            eliminarAnalisisUseCase: EliminarStub(service: service)
        )
    }

    // MARK: - Tests

    @Test @MainActor
    func loadAnalisisSuccess() async throws {
        let items = [Analisis(id: "1", titulo: "BM", fecha: Date(), tipo: "Lab")]
        let sut = makeViewModel(fetch: .success(items), delete: .success(()))

        sut.onAnalisisScreenLoaded()
        try await Task.sleep(nanoseconds: 50_000_000)

        #expect(sut.isLoading == false)
        #expect(sut.analisis == items)
        #expect(sut.errorMessage == nil)
    }

    @Test @MainActor
    func loadAnalisisFailure_setsError() async throws {
        let sut = makeViewModel(fetch: .failure(NetworkError.serverError(status: 500)), delete: .success(()))

        sut.onAnalisisScreenLoaded()
        try await Task.sleep(nanoseconds: 50_000_000)

        #expect(sut.isLoading == false)
        #expect(sut.analisis.isEmpty)
        #expect(sut.errorMessage != nil)
    }

    @Test @MainActor
    func deleteAnalisisSuccess_removesItemAndShowsSuccess() async throws {
        let items = [Analisis(id: "1", titulo: "BM", fecha: Date(), tipo: "Lab")]
        let sut = makeViewModel(fetch: .success(items), delete: .success(()))
        sut.analisis = items

        sut.onEliminarAnalisisClicked(idAnalisis: "1")
        sut.onConfirmarEliminacion(idAnalisis: "1")
        try await Task.sleep(nanoseconds: 50_000_000)

        #expect(sut.analisis.isEmpty)
        #expect(sut.showSuccessMessage)
        #expect(sut.showDeleteConfirmation == false)
    }

    @Test @MainActor
    func deleteAnalisisFailure_setsError() async throws {
        let items = [Analisis(id: "1", titulo: "BM", fecha: Date(), tipo: "Lab")]
        let sut = makeViewModel(fetch: .success(items), delete: .failure(NetworkError.serverError(status: 500)))
        sut.analisis = items

        sut.onEliminarAnalisisClicked(idAnalisis: "1")
        sut.onConfirmarEliminacion(idAnalisis: "1")
        try await Task.sleep(nanoseconds: 50_000_000)

        #expect(sut.analisis.isEmpty == false)
        #expect(sut.errorMessage != nil)
        #expect(sut.showDeleteConfirmation == false)
        #expect(sut.showSuccessMessage == false)
    }
}
