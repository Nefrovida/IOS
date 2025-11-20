import Foundation

// Concrete implementation of the GetReportsUseCaseProtocol
// Handles the business logic for retrieving reports for a specific user
final class GetReportsUseCase: GetReportsUseCaseProtocol {
    private let repository: ReportsRepositoryProtocol
    
    init(repository: ReportsRepositoryProtocol) {
        self.repository = repository
    }

    func execute(patientId: String) async throws -> [Report] {
        try await repository.fetchReports(for: patientId)
    }
}
