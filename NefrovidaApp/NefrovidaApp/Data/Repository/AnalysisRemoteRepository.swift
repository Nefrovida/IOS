import Foundation
import Alamofire

final class AnalysisRemoteRepository: AnalysisRepositoryProtocol {

    private let baseURL = "http://localhost:3001"

    func fetchAnalysisList() async throws -> [Analysis] {

        let endpoint = "\(baseURL)/api/analysis"

        let request = AF.request(endpoint, method: .get).validate()
        let result = await request.serializingData().response

        switch result.result {
        case .success(let data):
            let decoded = try JSONDecoder().decode(AnalysisResponse.self, from: data)
            return decoded.data

        case .failure(let error):
            print("ERROR FETCHING ANALYSIS:", error)
            throw error
        }
    }
}
