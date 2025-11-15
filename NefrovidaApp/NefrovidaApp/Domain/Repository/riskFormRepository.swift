import Foundation

protocol RiskFormRepositoryProtocol {
    func submitForm(idUser: String, forms: [String: Any]) async throws
}

protocol RiskQuestionsRepositoryProtocol {
    func fetchQuestions() async throws -> [RiskQuestion]
}

protocol GetRiskOptionsRepositoryProtocol {
    func fetchOptions() async throws -> [RiskOption]
}

protocol SubmitRiskFormUseCaseProtocol {
    func execute(idUser: String, forms: [String: Any]) async throws
}

protocol GetRiskQuestionsUseCaseProtocol {
    func execute() async throws -> [RiskQuestion]
}

protocol GetRiskOptionsUseCaseProtocol {
    func execute() async throws -> [RiskOption]
}
