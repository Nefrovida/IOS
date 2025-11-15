import Foundation

// Protocols to define the operations of the repository.

// Protocol that define what the repository
// of submit risk form recive and what return.
protocol RiskFormRepositoryProtocol {
    // Send risk form to the api.
    //Parameters: idUser: ID of the current user.
    //forms: Dictionary of the form.
    func submitForm(idUser: String, forms: [String: Any]) async throws
}

// Protocol of the repository to get the questions
// this one define what the need to return.
protocol RiskQuestionsRepositoryProtocol {
    // Get the question of the api.
    func fetchQuestions() async throws -> [RiskQuestion]
}


// Protocol of the repository that get the options
// for the questions, this one define what need to
// return.
protocol GetRiskOptionsRepositoryProtocol {
    //Get all the options from the api.
    func fetchOptions() async throws -> [RiskOption]
}


//Protocols of the uses cases.

//protocol to send the forms to the api.
protocol SubmitRiskFormUseCaseProtocol {
    // Execute the action of send the forms.
    // parameters: idUser: id of the current user.
    // forms: dictionary of the question and answer.
    func execute(idUser: String, forms: [String: Any]) async throws
}


 // protocol to get the riskquestion.
protocol GetRiskQuestionsUseCaseProtocol {
    // Execute the action of get the risk question.
    func execute() async throws -> [RiskQuestion]
}

//Protocol to get the options of the questions.
protocol GetRiskOptionsUseCaseProtocol {
    // Execute the action of get the options of the questions.
    func execute() async throws -> [RiskOption]
}
