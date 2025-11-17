import Foundation

protocol AnalysisRepositoryProtocol {
    func fetchAnalysisList() async throws -> [Analysis]
}

protocol GetAnalysisUseCaseProtocol {
    func execute() async throws -> [Analysis]
}

protocol ConsultationRepositoryProtocol {
    func fetchConsultationList() async throws -> [Consultation]
}

protocol GetConsultationUseCaseProtocol {
    func execute() async throws -> [Consultation]
}
