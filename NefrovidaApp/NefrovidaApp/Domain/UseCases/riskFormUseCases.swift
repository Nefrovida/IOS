import Foundation

final class SubmitRiskFormUseCase: SubmitRiskFormUseCaseProtocol {
    
    private let repository: RiskFormRepositoryProtocol

    init(repository: RiskFormRepositoryProtocol) {
        self.repository = repository
    }

    func execute(idUser: String, forms: [String: Any]) async throws {
        try await repository.submitForm(idUser: idUser, forms: forms)
    }
    
    func validate(forms: [String : Any]) throws -> Bool {
        return true
    }
}

final class GetRiskQuestionsUseCase: GetRiskQuestionsUseCaseProtocol {
    
    private let repository: RiskQuestionsRepositoryProtocol
    
    init(repository: RiskQuestionsRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [RiskQuestion] {
        try await repository.fetchQuestions()
    }
}

final class GetRiskOptionsUseCases: GetRiskOptionsUseCaseProtocol {
    
    private let repository: GetRiskOptionsRepositoryProtocol
    
    init(repository: GetRiskOptionsRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [RiskOption] {
        try await repository.fetchOptions()
    }
}
