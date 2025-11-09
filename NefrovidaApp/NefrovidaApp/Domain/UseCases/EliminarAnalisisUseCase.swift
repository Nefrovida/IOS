//  EliminarAnalisisUseCase.swift
//  NefrovidaApp
//
//  Created by Enrique Ayala on 08/11/25.
//
//  Use case for deleting a specific Analisis.

import Foundation

/// Abstraction for deleting an analysis for DI and testing.
protocol EliminarAnalisisUseCaseProtocol {
    func execute(id: String) async throws
}

/// Default implementation of delete analysis use case.
struct EliminarAnalisisUseCase: EliminarAnalisisUseCaseProtocol {
    private let service: AnalisisServiceProtocol

    init(service: AnalisisServiceProtocol = AnalisisService()) {
        self.service = service
    }

    func execute(id: String) async throws {
        try await service.deleteAnalisis(id: id)
    }
}
