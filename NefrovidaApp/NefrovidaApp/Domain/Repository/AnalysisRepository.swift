import Foundation

// Protocol defining the responsibilities of a repository that fetches analysis data
protocol AnalysisRepositoryProtocol {
    // Fetches a list of analyses asynchronously, throws an error if something goes wrong
    func fetchAnalysisList() async throws -> [Analysis]
}

// Protocol defining the responsibilities of a use case for retrieving analyses
protocol GetAnalysisUseCaseProtocol {
    // Executes the use case to retrieve analyses, throws an error if failed
    func execute() async throws -> [Analysis]
}

// Protocol defining the responsibilities of a repository that fetches consultation data
protocol ConsultationRepositoryProtocol {
    // Fetches a list of consultations asynchronously, throws an error if something goes wrong
    func fetchConsultationList() async throws -> [Consultation]
}

// Protocol defining the responsibilities of a use case for retrieving consultations
protocol GetConsultationUseCaseProtocol {
    // Executes the use case to retrieve consultations, throws an error if failed
    func execute() async throws -> [Consultation]
}
