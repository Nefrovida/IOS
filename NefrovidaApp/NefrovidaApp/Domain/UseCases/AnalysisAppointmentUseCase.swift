//
//  AnalysisAppointmentUseCase.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 25/11/25.
//

import Foundation

// UseCase responsible for retrieving analysis for a specific day.
struct getAnalysisUseCase {
    let repository: AnalysisRepository
    
    func execute(date: Date, analysisId: Int) async throws -> [AnalysisEntity] {
        try await repository.getAnalysis(for: date, analysisId: analysisId)
    }
}

struct CreateAnalysisUseCase {
    let repository: AnalysisRepository
    
    func execute(
        userId: String,
        analysisId: Int,
        analysisDate: Date,
        place: String?
    ) async throws -> AnalysisEntity {
        try await repository.createAnalysis(
            userId: userId,
            analysisId: analysisId,
            analysisDate: analysisDate,
            place: place
        )
    }
}
