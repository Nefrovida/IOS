import Foundation

// Concrete implementation of the GetReportsUseCaseProtocol
// Handles the business logic for retrieving reports for a specific user
final class GetReportsUseCase: GetReportsUseCaseProtocol {
    
    // Repository responsible for fetching report data (e.g., API or database)
    private let repository: ReportsRepositoryProtocol
    
    // Dependency Injection: the repository is provided via initializer
    init(repository: ReportsRepositoryProtocol) {
        self.repository = repository
    }

    // Executes the use case: fetches reports for the given userId
    // Delegates the actual data fetching to the repository
    func execute(userId: String) async throws -> [Report] {
        try await repository.fetchReports(for: userId)
    }
}
