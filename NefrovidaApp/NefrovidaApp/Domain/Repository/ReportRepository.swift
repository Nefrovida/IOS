import Foundation

// Use Case Protocol for fetching reports
// Encapsulates the business logic for retrieving reports for a given user
protocol ReportsRepositoryProtocol {
    func fetchReports(for patientId: String) async throws -> [Report]
}

protocol GetReportsUseCaseProtocol {
    func execute(patientId: String) async throws -> [Report]
}
