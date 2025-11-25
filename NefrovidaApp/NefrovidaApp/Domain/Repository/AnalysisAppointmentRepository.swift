//
//  AnalysisAppointmentRepository.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 25/11/25.
//

import Foundation

// Protocol that defines the contract for any analysis repository.
// This allows you to:
// - Swap the data source easily (e.g., real API, mock data, offline mode)
// - Write unit tests by mocking the repository
// - Keep the ViewModels independent of networking logic
protocol AnalysisRepository {
    // Fetch all analysis for a given date and analysis type.
    func getAnalysis(for date: Date, analysisId: Int) async throws -> [AnalysisEntity]
    
    // Creates a new analysis appointment for a user at a specific date and time.
    func createAnalysis(
        userId: String,
        analysisId: Int,
        analysisDate: Date,
        place: String?
    ) async throws -> AnalysisEntity
}
