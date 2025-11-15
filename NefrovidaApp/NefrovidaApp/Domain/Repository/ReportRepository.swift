import Foundation


protocol GetReportsUseCaseProtocol {
    func execute(userId: String) async throws -> [Report]
}

protocol ReportsRepositoryProtocol {
    func fetchReports(for userId: String) async throws -> [Report]
}
