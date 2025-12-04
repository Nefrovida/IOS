import Foundation

protocol DownloadReportUseCaseProtocol {
    func execute(id: Int) async throws -> URL
}

final class DownloadReportUseCase: DownloadReportUseCaseProtocol {
    private let repository: ReportsRepositoryProtocol
    
    init(repository: ReportsRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(id: Int) async throws -> URL {
        try await repository.downloadReport(id: id)
    }
}
