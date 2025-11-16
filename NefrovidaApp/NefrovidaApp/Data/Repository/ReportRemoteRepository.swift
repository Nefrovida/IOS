import Foundation
import Alamofire

final class ReportsRemoteRepository: ReportsRepositoryProtocol {

    private let baseURL = "http://localhost:3001"

    func fetchReports(for userId: String) async throws -> [Report] {
        let endpoint = "\(baseURL)/api/report/get-result/\(userId)"
        
        let request = AF.request(endpoint, method: .get).validate()
        let response = await request.serializingData().response
        
        switch response.result {
        case .success(let data):
            let decoded = try JSONDecoder().decode(Report.self, from: data)
            return [decoded] // convert to array for UI compatibility
        case .failure(let error):
            print("Error fetching reports:", error)
            throw error
        }
    }
}
