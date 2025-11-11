protocol SubmitRiskFormUseCaseProtocol {
    func execute(form: RiskForm) async throws
}

final class SubmitRiskFormUseCase: SubmitRiskFormUseCaseProtocol {
    private let repository: RiskFormRepositoryProtocol
    
    init(repository: RiskFormRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(form: RiskForm) async throws {
        try await repository.submitForm(form)
    }
}

