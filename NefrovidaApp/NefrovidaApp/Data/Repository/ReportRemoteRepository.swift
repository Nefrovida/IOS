import Foundation
import Alamofire

// Repository class responsible for fetching reports from the backend API.
// Implements the ReportsRepositoryProtocol required by the domain layer.
final class ReportsRemoteRepository: ReportsRepositoryProtocol {

    // Fetches one or multiple reports for a given patient ID.
    // Returns an array because the API may return a single report or a list.
    func fetchReports(for userId: String) async throws -> [Report] {

        // Builds the full API endpoint.
        let endpoint = "\(AppConfig.apiBaseURL)/report/get-results-ios/\(userId)"

        // Sends a GET request to the server using Alamofire.
        let request = AF.request(endpoint, method: .get).validate()

        // Awaits the network response as raw Data.
        let response = await request.serializingData().response

        // Handles success or error from the HTTP request.
        switch response.result {

        // ✔ Successful HTTP response
        case .success(let data):
            do {
                // Attempts to decode the response into the flexible ReportResponse model.
                let decoded = try JSONDecoder().decode(ReportResponse.self, from: data)

                // Handles both supported formats: single report OR array.
                switch decoded.data {

                case .single(let report):
                    // Wraps a single report into an array to maintain consistency.
                    return [report]

                case .list(let reports):
                    // Returns the full list when the API sends multiple reports.
                    return reports
                }

            } catch {
                // Prints decoding issues for debugging.
                print("Decoding error:", error)
                throw error
            }

        // Request failed (network, 4xx, 5xx, etc.)
        case .failure(let error):
            print("Error fetching reports:", error)
            throw error
        }
    }
}
