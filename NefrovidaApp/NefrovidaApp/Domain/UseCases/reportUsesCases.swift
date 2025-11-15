import Foundation

final class GetReportsUseCase: GetReportsUseCaseProtocol {
    private let repository: ReportsRepositoryProtocol
    
    init(repository: ReportsRepositoryProtocol) {
        self.repository = repository
    }

    func execute(userId: String) async throws -> [Report] {
        try await repository.fetchReports(for: userId)
    }
}
