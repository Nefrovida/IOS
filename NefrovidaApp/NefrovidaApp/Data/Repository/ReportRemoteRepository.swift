import Foundation
import Alamofire

// Repository class responsible for fetching reports from the backend API.
// Implements the ReportsRepositoryProtocol required by the domain layer.
final class ReportsRemoteRepository: ReportsRepositoryProtocol {

    func fetchReports(for userId: String) async throws -> PatientReportsData {

        let endpoint = "\(AppConfig.apiBaseURL)/report/get-results-ios/\(userId)"

        let response = await AF.request(endpoint, method: .get)
            .validate()
            .serializingData()
            .response

        switch response.result {
        case .success(let data):
            do {
                let decoded = try JSONDecoder().decode(PatientReportsResponse.self, from: data)
                return decoded.data
            } catch {
                print("Decoding error:", error)
                throw error
            }

        case .failure(let error):
            print("Error fetching reports:", error)
            throw error
        }
    }
}
