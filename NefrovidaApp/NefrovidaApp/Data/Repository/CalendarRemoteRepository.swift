import Foundation
import Alamofire

// Repository connected to the api and get the appointments and analysis.
final class RemoteAppointmentRepository: AppointmentRepository {
    
    // Method that make a fetch to get the appointments and the analysis depending of the IdUser.
    // Parameters: idUser: Id of the user in the sesion.
    // Returns: Array of Appointments and analysis.
    // Throws: Error if the conection fails or the decode.
    func fetchAppointments(idUser: String) async throws -> [Appointment] {
        
       
        let endpoint = "\(AppConfig.apiBaseURL)/appointments/user/\(idUser)"
        
        // Make a get request and validate the http code is a 2xx.
        let result = await AF.request(endpoint, method: .get)
            .validate()
            .serializingData()
            .response

        // Evaluation of the result of the hhtp result.
        switch result.result {
        case .success(let data):
            // If the response is successfully, try to decode the json.
            let response = try JSONDecoder().decode(AppointmentsResponse.self, from: data)
            print("se obtuvo las citas")

            // Make a temporal array with the appointments that get by the backend.
            var combined: [Appointment] = response.appointments

            // Map the analysis to adopt the struct.
            // To show in the same calendar.
            let mappedAnalysis = response.analysis.map {
                Appointment(
                    patientAppointmentId: $0.patientAnalysisId,
                    patientId: $0.patientId,
                    appointmentId: $0.analysisId,
                    dateHour: $0.analysisDate,
                    duration: $0.duration,
                    appointmentType: "ANÁLISIS",
                    link: nil,
                    place: $0.place,
                    appointmentStatus: $0.analysisStatus,
                    appointmentInfo: AppointmentInfo(
                        name: $0.analysis?.name.trimmingCharacters(in: .whitespacesAndNewlines)
                            ?? "Análisis"
                    )
                )
            }
            // Add the analysis to the array of the appointment.
            combined.append(contentsOf: mappedAnalysis)

            // return the array.
            return combined

        case .failure(let error):
            throw error
        }
    }
}

final class RemoteCancelAppointmentRepository: CancelAppointmentRepository {

    func cancelAppointment(id: Int) async throws {
        let url = "\(AppConfig.apiBaseURL)/appointments/\(id)/cancel"

        let response = await AF.request(url, method: .post)
            .validate()
            .serializingData()
            .response

        switch response.result {
        case .success:
            print("🟢 Cita cancelada con éxito")
        case .failure(let error):
            throw error
        }
    }
}

final class RemoteCancelAnalysisRepository: CancelAnalysisRepository {
    func cancelAnalysis(id: Int) async throws {
        let url = "\(AppConfig.apiBaseURL)/analysis/\(id)/cancel"

        let response = await AF.request(url, method: .post)
            .validate()
            .serializingData()
            .response

        switch response.result {
        case .success:
            print("🟢 Análisis cancelado con éxito")
        case .failure(let error):
            throw error
        }
    }
}
