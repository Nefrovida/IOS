import Foundation
import Alamofire

// Repository responsible for fetching analysis data from the backend.
final class AnalysisRemoteRepository: AnalysisRepositoryProtocol {

    // Fetches a list of analyses as an async operation
    func fetchAnalysisList() async throws -> [Analysis] {

        // Defines the specific endpoint for fetching analysis data
        let endpoint = "\(AppConfig.apiBaseURL)/analysis"

        // Makes the HTTP request using Alamofire, validating for errors
        let request = AF.request(endpoint, method: .get).validate()
        let result = await request.serializingData().response

        // Switch based on whether the request succeeded or failed
        switch result.result {
        case .success(let data):
            // Decodes the backend response into the `AnalysisResponse` structure
            let decoded = try JSONDecoder().decode(AnalysisResponse.self, from: data)
            return decoded.data  // Returns just the list of analyses

        case .failure(let error):
            // Prints and throws the error if the request or decoding fails
            print("ERROR FETCHING ANALYSIS:", error)
            throw error
        }
    }
}

// Repository responsible for fetching consultation data from the backend.
final class ConsultationRemoteRepository: ConsultationRepositoryProtocol {

    // Fetches a list of consultations as an async operation
    func fetchConsultationList() async throws -> [Consultation] {

        // Defines the specific endpoint for fetching consultation data
        let endpoint = "\(AppConfig.apiBaseURL)/appointments/getAllAppointments"

        // Makes the HTTP GET request and validates server response
        let request = AF.request(endpoint, method: .get).validate()
        let result = await request.serializingData().response

        // Switches based on the result of request execution
        switch result.result {
        case .success(let data):
            // Since the API directly returns an array, we decode `[Consultation]`
            let decoded = try JSONDecoder().decode([Consultation].self, from: data)
            print("se obtuvo las consultas")
            return decoded  // Returns the list of consultations

        case .failure(let error):
            // Logs the error and rethrows it for upper layers to handle
            print("ERROR FETCHING CONSULTATION:", error)
            throw error
        }
    }
}
