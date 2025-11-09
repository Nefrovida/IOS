//  ObtenerAnalisisUseCase.swift
//  NefrovidaApp
//
//  Created by Enrique Ayala on 08/11/25.
//
//  Use case for retrieving the list of Analisis from the repository/service layer.

import Foundation

/// Abstraction for fetching analyses for DI and testing.
protocol ObtenerAnalisisUseCaseProtocol {
    func execute() async throws -> [Analisis]
}

/// Default implementation of the fetch analyses use case.
struct ObtenerAnalisisUseCase: ObtenerAnalisisUseCaseProtocol {
    private let service: AnalisisServiceProtocol

    init(service: AnalisisServiceProtocol = AnalisisService()) {
        self.service = service
    }

    func execute() async throws -> [Analisis] {
        try await service.fetchAnalisis()
    }
}
