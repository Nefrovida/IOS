import Foundation
import Alamofire

// Repository class that fetches reports from the server
final class ReportsRemoteRepository: ReportsRepositoryProtocol {

    // Base URL for API endpoints
    private let baseURL = "http://localhost:3001"

    // Fetch a list of reports associated with a given user ID
    func fetchReports(for userId: String) async throws -> [Report] {
        // Construct the endpoint URL using string interpolation
        let endpoint = "\(baseURL)/api/report/get-result/\(userId)"
        
        // Create and validate the GET request using Alamofire
        let request = AF.request(endpoint, method: .get).validate()
        let response = await request.serializingData().response
        
        // Handle the result of the request
        switch response.result {
        case .success(let data):
            do {
                // Decode the response into an array of Report models
                // Assuming the API returns a JSON array, adjust if needed
                let decoded = try JSONDecoder().decode([Report].self, from: data)
                return decoded
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
