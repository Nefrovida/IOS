import Foundation

protocol AnalysisRepositoryProtocol {
    func fetchAnalysisList() async throws -> [Analysis]
}

protocol GetAnalysisUseCaseProtocol {
    func execute() async throws -> [Analysis]
}
