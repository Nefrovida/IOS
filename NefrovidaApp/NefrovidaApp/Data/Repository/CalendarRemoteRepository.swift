import Foundation
import Alamofire
// Fetches appointment data from a remote API using Alamofire.
// Responsible for communicating with the backend and decoding the response into domain models.
public final class RemoteAppointmentRepository : AppointmentRepository {

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
    public func fetchAppointments(forDate date: String, idUser: String) async throws -> [Appointment] {

        let endpoint = "\(baseURL)/appointments"
        
        // Parameters for the GET request (query string)
        let params: Parameters = [
            "date": date,
            "idUser": idUser
        ]
        
        // Create and validate the request using Alamofire
        let request = AF.request(endpoint, method: .get, parameters: params).validate()
        // Await the asynchronous response
        let result = await request.serializingData().response

        // Handle the result of the request
        switch result.result {
        case .success(let data):
            do {
                // Decode the received JSON into an array of AppointmentDTO objects
                let dtoList = try JSONDecoder().decode([AppointmentDTO].self, from: data)
                // Convert each DTO to a domain model
                return dtoList.map { $0.toDomain() }
            } catch {
                // Throw decoding errors to the caller
                throw error
            }

        case .failure(let error):
            // Propagate networking or validation errors
            throw error
        }
    }
}
