import Foundation
import Alamofire

// Repository to send forms to the api.
final class RiskFormRepository: RiskFormRepositoryProtocol {

    // Send the forms to the api, using the id to identify.
    // Parameters: idUser: Id of the user in the sesion.
    // forms: Dictionary with the question and answer.
    // Throws: Error if the http request fail.
    func submitForm(idUser: String, forms: [String: Any]) async throws {
        
        // Final endpoint.
        let endpoint = "\(AppConfig.apiBaseURL)/clinical-history/risk-form/submit/\(idUser)"

        // Ejecution of the http request.
        let request = AF.request(
            endpoint,
            method: .post,
            parameters: forms,             // Send the forms.
            encoding: JSONEncoding.default // Make the forms in JSON format.
        )
        .validate() // Validate the petition. (200-299).

        // Esperamos la respuesta en formato Data
        // Await of the http request.
        let result = await request.serializingData().response

        // Imprime el estatus HTTP para debugging
        // Print the status of http request.
        if let status = result.response?.statusCode {
            print("HTTP Status:", status)
        }

        // Check if the petition is success or fail.
        switch result.result {
        case .success:
            print("Form send successfully.")
        case .failure(let error):
            print("Error POST:", error)
            throw error
        }
    }
}


// Repository to get the risk questions.
final class RiskQuestionsRepository: RiskQuestionsRepositoryProtocol {

    // Get all the risk questions.
    // Returns: Array of RiskQuestion.
    // Throws: Error if the http request fail or the JSON parse fail.
    func fetchQuestions() async throws -> [RiskQuestion] {

        let endpoint = "\(AppConfig.apiBaseURL)/clinical-history/risk-questions"

        let result = await AF.request(endpoint, method: .get)
            .validate()
            .serializingData()
            .response

        switch result.result {
        case .success(let data):
            // Decode JSON to our model.
            let response = try JSONDecoder().decode([RiskQuestion].self, from: data)
            print("se obtuvo los datos")
            print("📌 RAW JSON:")
            print(String(data: data, encoding: .utf8)!)
            return response

        case .failure(let error):
            print("Fail to get the questions:", error)
            throw error
        }
    }
}


// Repository to get the options of choice questions.
final class RiskOptionsRepository: GetRiskOptionsRepositoryProtocol {

    // Get all the options.
    // Returns: Array of RiskOption.
    // Throws: Error if the http request fail.
    func fetchOptions() async throws -> [RiskOption] {

        let endpoint = "\(AppConfig.apiBaseURL)/clinical-history/risk-options"

        // Make a GET and validate.
        let result = await AF.request(endpoint, method: .get)
            .validate()
            .serializingData()
            .response

        switch result.result {
        case .success(let data):
            // Decode JSON into our model.
            let response = try JSONDecoder().decode([RiskOption].self, from: data)
            print("se obtuvo las opciones")
            return response

        case .failure(let error):
            print("Fail to get the questions:", error)
            throw error
        }
    }
}
