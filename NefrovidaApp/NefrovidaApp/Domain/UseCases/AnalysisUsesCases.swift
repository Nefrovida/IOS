import Foundation

final class GetAnalysisUseCase: GetAnalysisUseCaseProtocol {

    private let repository: AnalysisRepositoryProtocol

    init(repository: AnalysisRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [Analysis] {
        try await repository.fetchAnalysisList()
    }
}

final class GetConsultationUseCases: GetConsultationUseCaseProtocol {
    
    private let repository: ConsultationRepositoryProtocol
    
    init(repository: ConsultationRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [Consultation] {
        try await repository.fetchConsultationList()
    }
}
