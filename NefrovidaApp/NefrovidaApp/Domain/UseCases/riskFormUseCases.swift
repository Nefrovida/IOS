import Foundation

// Use case responsible for submitting the risk form.
// It acts as an intermediary between the ViewModel and the repository.
final class SubmitRiskFormUseCase: SubmitRiskFormUseCaseProtocol {
    
    // Reference to the repository that performs the network request.
    private let repository: RiskFormRepositoryProtocol

    // Initializes the use case with its corresponding repository.
    init(repository: RiskFormRepositoryProtocol) {
        self.repository = repository
    }

    // Executes the submission of the form by delegating to the repository.
    // Parameters:idUser: Unique identifier of the user submitting the form.
    // forms: Dictionary containing the mapped answers.
    func execute(idUser: String, forms: [String: Any]) async throws {
        try await repository.submitForm(idUser: idUser, forms: forms)
    }
    
    // Validation method (currently always returns true).
    // Helps check that there are no empty fields.
    // This can be expanded to validate the form before submission.
    func validate(forms: [String : Any]) throws -> Bool {
        return true
    }
}

// Use case responsible for retrieving all risk questions from the API.
final class GetRiskQuestionsUseCase: GetRiskQuestionsUseCaseProtocol {
    
    // Repository that interfaces with the backend.
    private let repository: RiskQuestionsRepositoryProtocol
    
    // Initializes the use case with the provided repository.
    init(repository: RiskQuestionsRepositoryProtocol) {
        self.repository = repository
    }
    
    // Executes the request to fetch all questions.
    // Returns an array of `RiskQuestion` models.
    func execute() async throws -> [RiskQuestion] {
        try await repository.fetchQuestions()
    }
}

// Use case responsible for retrieving all available options
// for the risk form questions from the backend.
final class GetRiskOptionsUseCases: GetRiskOptionsUseCaseProtocol {
    
    // Repository that fetches the options from the API.
    private let repository: GetRiskOptionsRepositoryProtocol
    
    // Initializes the use case with the corresponding repository.
    init(repository: GetRiskOptionsRepositoryProtocol) {
        self.repository = repository
    }
    
    // Executes the request to fetch all question options.
    // Returns an array of `RiskOption`.
    func execute() async throws -> [RiskOption] {
        try await repository.fetchOptions()
    }
}
