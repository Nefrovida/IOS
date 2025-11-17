import Foundation

// Use case responsible for retrieving a list of analyses
final class GetAnalysisUseCase: GetAnalysisUseCaseProtocol {

    // Dependency on a repository that handles the data fetching logic
    private let repository: AnalysisRepositoryProtocol

    // Initializes the use case with a specific implementation of the repository
    init(repository: AnalysisRepositoryProtocol) {
        self.repository = repository
    }

    // Executes the use case by delegating to the repository to fetch the data
    func execute() async throws -> [Analysis] {
        try await repository.fetchAnalysisList()
    }
}

// Use case responsible for retrieving a list of consultations
final class GetConsultationUseCases: GetConsultationUseCaseProtocol {
    
    // Dependency on a repository that handles the data fetching logic for consultations
    private let repository: ConsultationRepositoryProtocol
    
    // Initializes the use case with a specific implementation of the repository
    init(repository: ConsultationRepositoryProtocol) {
        self.repository = repository
    }
    
    // Executes the use case by delegating to the repository to fetch the data
    func execute() async throws -> [Consultation] {
        try await repository.fetchConsultationList()
    }
}
