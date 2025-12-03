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
