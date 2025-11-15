import Foundation
import Alamofire

// Repository responsible for fetching all reports for a specific user from the backend.
final class ReportsRemoteRepository: ReportsRepositoryProtocol {

    // Base endpoint of your backend API
    private let baseURL = "http://192.168.1.163:3001"

    // Fetches all reports for a user based on their ID.
    // Parameters: userId: String representing the current user's ID.
    // Returns: Array of `Report` entities sorted by date (descending).
    // Throws: Error if the network request fails or JSON parsing fails.
    func fetchReports(for userId: String) async throws -> [Report] {
        
        // Dynamically build the endpoint
        let endpoint = "\(baseURL)/api/report/get-result/\(userId)"

        // Setup and execute the GET request
        let request = AF.request(endpoint, method: .get)
            .validate()  // Ensures status code is 200-299

        // Await raw data response
        let result = await request.serializingData().response

        // Check HTTP status for debugging
        if let status = result.response?.statusCode {
            print("HTTP Status:", status)
        }

        // Handle success/failure
        switch result.result {
        case .success(let rawData):
        
            // Decode JSON -> [Report]
            let reports = try JSONDecoder().decode([Report].self, from: rawData)
            
            // Sort them by date (descending)
            return reports.sorted(by: { $0.date > $1.date })

        case .failure(let error):
            print("Error GET:", error)
            throw error
        }
    }
}
