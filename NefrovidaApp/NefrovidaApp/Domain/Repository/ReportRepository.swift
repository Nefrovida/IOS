import Foundation

// Use Case Protocol for fetching reports
// Encapsulates the business logic for retrieving reports for a given user
protocol ReportsRepositoryProtocol {
    func fetchReports(for userId: String) async throws -> PatientReportsData
    func downloadReport(id: Int) async throws -> URL
}

protocol GetReportsUseCaseProtocol {
    func execute(userId: String) async throws -> PatientReportsData
}


