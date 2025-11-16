import Foundation
import Alamofire

// Repository to send forms to the api.
final class RiskFormRepository: RiskFormRepositoryProtocol {

    // endpoint to connect to the api and send data.
    // if you want to try it, put your ip.
    private let baseURL = "http://localhost:3001"

    //Envía el formulario completo al backend usando el ID del usuario.
    // Send the forms to the api, using the id to identify.
    // Parameters: idUser: Id of the user in the sesion.
    ///   - forms: Diccionario con todos los datos del formulario (general_info + answers).
    ///
    /// - Throws: Lanza error si la petición HTTP falla.
    func submitForm(idUser: String, forms: [String: Any]) async throws {
        
        // Endpoint final para el POST: /risk-form/submit/:idUser
        let endpoint = "\(baseURL)/api/clinical-history/risk-form/submit/\(idUser)"

        // Configuración y ejecución del request HTTP
        let request = AF.request(
            endpoint,
            method: .post,
            parameters: forms,             // Se envía el diccionario completo
            encoding: JSONEncoding.default // Se codifica como JSON en el body
        )
        .validate() // Valida códigos HTTP 200...299

        // Esperamos la respuesta en formato Data
        let result = await request.serializingData().response

        // Imprime el estatus HTTP para debugging
        if let status = result.response?.statusCode {
            print("HTTP Status:", status)
        }

        // Revisamos si la petición fue exitosa o falló
        switch result.result {
        case .success:
            print("Formulario enviado correctamente")
        case .failure(let error):
            print("Error POST:", error)
            throw error
        }
    }
}


// =======================================================
// Repositorio encargado de OBTENER todas las preguntas
// =======================================================
final class RiskQuestionsRepository: RiskQuestionsRepositoryProtocol {

    private let baseURL = "http://localhost:3001"

    /// Obtiene todas las preguntas disponibles del formulario dinámico.
    ///
    /// - Returns: Arreglo de objetos `RiskQuestion`
    /// - Throws: Error si falla la petición o el parseo de JSON.
    func fetchQuestions() async throws -> [RiskQuestion] {

        let endpoint = "\(baseURL)/api/clinical-history/risk-options"

        // Realizamos el GET y validamos la respuesta
        let result = await AF.request(endpoint, method: .get)
            .validate()
            .serializingData()
            .response

        switch result.result {
        case .success(let data):
            // Decodificamos el JSON recibido hacia nuestro modelo Swift
            let response = try JSONDecoder().decode([RiskQuestion].self, from: data)
            return response

        case .failure(let error):
            print("Error al obtener preguntas:", error)
            throw error
        }
    }
}


// =======================================================
// Repositorio encargado de OBTENER las opciones (choice)
// =======================================================
final class RiskOptionsRepository: GetRiskOptionsRepositoryProtocol {

    private let baseURL = "http://localhost:3001"

    /// Obtiene todas las opciones asociadas a preguntas tipo choice.
    ///
    /// - Returns: Arreglo de objetos `RiskOption`
    /// - Throws: Error si falla la petición HTTP.
    func fetchOptions() async throws -> [RiskOption] {

        let endpoint = "\(baseURL)/api/clinical-history/risk-options"

        // Hacemos GET y validamos
        let result = await AF.request(endpoint, method: .get)
            .validate()
            .serializingData()
            .response

        switch result.result {
        case .success(let data):
            // Decodificación estándar
            let response = try JSONDecoder().decode([RiskOption].self, from: data)
            return response

        case .failure(let error):
            print("Error al obtener preguntas:", error)
            throw error
        }
    }
}
