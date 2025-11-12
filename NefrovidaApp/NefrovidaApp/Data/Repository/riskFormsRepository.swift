import Alamofire
import Foundation

final class RiskFormRepository: RiskFormRepositoryProtocol {


private let baseURL: String

// Repository initializer, allows dependency injection of the baseURL.
public init(baseURL: String) {
    self.baseURL = baseURL
}

// Fetches appointments for a specific date from the remote API.
// Parameter date: String representing the date (format "yyyy-MM-dd").
// idUser: The identifier of the user whose appointments will be fetched.
// Returns: An array of Appointment objects (domain models).
// Throws: Any network or decoding error that occurs during the request.
    func submitForm(_ form: RiskForm) async throws {
        let endpoint = "\(baseURL)/riskForm"
        
        let params: Parameters = [
            "riskForm": form
        ]
        
        let request = AF.request(endpoint, method: .post, parameters: params).validate()
        let result = await request.serializingData().response
        
        // 🔹 Obtener el código HTTP
        if let statusCode = result.response?.statusCode {
            print("Código HTTP recibido: \(statusCode)")
        }

        switch result.result {
        case .success(_):
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                print("Formulario enviado correctamente")
                // Si quieres, también podrías decodificar la respuesta aquí
            }
        case .failure(let error):
            print("Error de red o validación: \(error)")
            throw error
        }
    }
}
