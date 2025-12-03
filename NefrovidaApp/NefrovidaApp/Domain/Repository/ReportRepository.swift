import Foundation

// Use Case Protocol for fetching reports
// Encapsulates the business logic for retrieving reports for a given user
protocol ReportsRepositoryProtocol {
<<<<<<< HEAD
    func fetchReports(for userId: String) async throws -> PatientReportsData
=======
    func fetchReports(for userId: String) async throws -> [Report]
    func downloadReport(id: Int) async throws -> URL
>>>>>>> c343b9bd85718c92d6ffadd9e3b037eba5196fd0
}

protocol GetReportsUseCaseProtocol {
    func execute(userId: String) async throws -> PatientReportsData
}


