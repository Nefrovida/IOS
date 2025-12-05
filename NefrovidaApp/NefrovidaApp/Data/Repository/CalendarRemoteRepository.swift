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
            
            let adjustedAppointments = response.appointments.map { appointment -> Appointment in
                let adjustedDateString = adjustDateString(appointment.dateHour, addingHours: 6)
                
                return Appointment(
                    patientAppointmentId: appointment.patientAppointmentId,
                    patientId: appointment.patientId,
                    appointmentId: appointment.appointmentId,
                    dateHour: adjustedDateString,
                    duration: appointment.duration,
                    appointmentType: appointment.appointmentType,
                    link: appointment.link,
                    place: appointment.place,
                    appointmentStatus: appointment.appointmentStatus,
                    appointmentInfo: appointment.appointmentInfo
                )
            }
            
            var combined: [Appointment] = adjustedAppointments
            
            let mappedAnalysis = response.analysis.map { analysis -> Appointment in
                let adjustedDateString = adjustDateString(analysis.analysisDate, addingHours: 6)
                
                return Appointment(
                    patientAppointmentId: analysis.patientAnalysisId,
                    patientId: analysis.patientId,
                    appointmentId: analysis.analysisId,
                    dateHour: adjustedDateString,
                    duration: analysis.duration,
                    appointmentType: "ANÁLISIS",
                    link: nil,
                    place: analysis.place,
                    appointmentStatus: analysis.analysisStatus,
                    appointmentInfo: AppointmentInfo(
                        name: analysis.analysis?.name.trimmingCharacters(in: .whitespacesAndNewlines)
                        ?? "Análisis"
                    ),
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
    
    private func adjustDateString(_ dateString: String, addingHours hours: Int) -> String {
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        iso.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard let date = iso.date(from: dateString),
              let adjustedDate = Calendar.current.date(byAdding: .hour, value: hours, to: date) else {
            print("⚠️ No se pudo ajustar la fecha: \(dateString)")
            return dateString
        }
        
        let adjustedString = iso.string(from: adjustedDate)
        print("📅 Adjusted: \(dateString) -> \(adjustedString)")
        return adjustedString
    }
    
    func CancelAnalysis(id: Int) async throws -> Bool {
        let endpoint = "\(AppConfig.apiBaseURL)/agenda/analysis/\(id)/cancel"
        
        guard let token = AppConfig.tokenProvider() else {
            return false
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        let result = await AF.request(endpoint, method: .post, headers: headers)
            .validate(statusCode: 200..<300)
            .serializingData()
            .response
        
        switch result.result {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    func CancelAppointment(id: Int) async throws -> Bool {
        let endpoint = "\(AppConfig.apiBaseURL)/agenda/appointments/\(id)/cancel"
        
        guard let token = AppConfig.tokenProvider() else {
            return false
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        let result = await AF.request(endpoint, method: .post, headers: headers)
            .validate()
            .serializingData()
            .response
        
        switch result.result {
        case .success:
            return true
        case .failure:
            return false
        }
    }
}
