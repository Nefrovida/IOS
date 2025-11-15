import Foundation
import Alamofire

final class RiskFormRepository: RiskFormRepositoryProtocol {
    
    private let baseURL = "http://192.168.1.163:3001"
    
    func submitForm(_ forms: [String : Any]) async throws {
        let endpoint = "\(baseURL)/api/report/risk-form"

        let request = AF.request(
            endpoint,
            method: .post,
            parameters: forms,
            encoding: JSONEncoding.default
        ).validate()
        
        let result = await request.serializingData().response
        
        if let status = result.response?.statusCode {
            print("HTTP Status:", status)
        }
        
        switch result.result {
        case .success:
            print("Formulario enviado correctamente")
        case .failure(let error):
            print("Error POST:", error)
            throw error
        }
    }
}

final class RiskQuestionsRepository: RiskQuestionsRepositoryProtocol {

    private let baseURL = "http://192.168.1.163:3001"

    func fetchQuestions() async throws -> [RiskQuestion] {

        let endpoint = "\(baseURL)/api/report/risk-questions"

        // Hacemos la petición EXACTAMENTE como tu repositorio base
        let result = await AF.request(endpoint, method: .get)
            .validate()
            .serializingData()
            .response

        switch result.result {
        case .success(let data):
            // Decodificamos igual que en base
            let response = try JSONDecoder().decode([RiskQuestion].self, from: data)
            return response

        case .failure(let error):
            print("Error al obtener preguntas:", error)
            throw error
        }
    }
}

final class RiskOptionsRepository: GetRiskOptionsRepositoryProtocol {

    private let baseURL = "http://192.168.1.163:3001"

    func fetchOptions() async throws -> [RiskOption] {

        let endpoint = "\(baseURL)/api/report/risk-options"

        // Hacemos la petición EXACTAMENTE como tu repositorio base
        let result = await AF.request(endpoint, method: .get)
            .validate()
            .serializingData()
            .response

        switch result.result {
        case .success(let data):
            // Decodificamos igual que en base
            let response = try JSONDecoder().decode([RiskOption].self, from: data)
            return response

        case .failure(let error):
            print("Error al obtener preguntas:", error)
            throw error
        }
    }
}
