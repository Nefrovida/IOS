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

    // Downloads a report PDF from the backend.
    // Returns the local URL of the downloaded file.
    func downloadReport(id: Int) async throws -> URL {
        
        // Endpoint for downloading the report
        let endpoint = "\(AppConfig.apiBaseURL)/analysis/download-report"
        
        // Parameters for the request
        let parameters: [String: String] = ["id": String(id)]
        
        // Destination closure to determine where to save the file
        let destination: DownloadRequest.Destination = { _, response in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(response.suggestedFilename ?? "report.pdf")
            
            // Overwrite if exists
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        // Perform the download
        return try await withCheckedThrowingContinuation { continuation in
            AF.download(endpoint, parameters: parameters, to: destination)
                .validate()
                .response { response in
                    switch response.result {
                    case .success(let fileURL):
                        if let fileURL = fileURL {
                            continuation.resume(returning: fileURL)
                        } else {
                            continuation.resume(throwing: URLError(.badServerResponse))
                        }
                    case .failure(let error):
                        print("Error downloading report:", error)
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}
