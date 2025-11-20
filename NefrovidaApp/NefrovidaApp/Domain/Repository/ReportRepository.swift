import Foundation

// Use Case Protocol for fetching reports
// Encapsulates the business logic for retrieving reports for a given user
protocol GetReportsUseCaseProtocol {
    // Executes the use case with a specified userId
    // Returns an array of Report models asynchronously or throws an error
    func execute(userId: String) async throws -> Report
}

// Repository Protocol for reports
// Abstracts the data source (remote, local, etc.) for fetching reports
protocol ReportsRepositoryProtocol {
    // Fetches reports associated with the specified user ID
    // Designed to be implemented by a repository layer (e.g., a remote REST API handler)
    func fetchReports(for userId: String) async throws -> Report
}
