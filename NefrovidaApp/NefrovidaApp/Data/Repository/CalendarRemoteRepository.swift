import Foundation
import Alamofire

final class RemoteAppointmentRepository: AppointmentRepository {
    private let baseURL = "http://10.25.98.27:3001"

    func fetchAppointments(forDate date: String, idUser: String) async throws -> [Appointment] {
        let endpoint = "\(baseURL)/api/users/appointments/\(idUser)"
        let result = await AF.request(endpoint, method: .get).validate().serializingData().response

        switch result.result {
        case .success(let data):
            let response = try JSONDecoder().decode(AppointmentsResponse.self, from: data)

            // Convertir DTOs → Domain Models
            var combined: [Appointment] = response.appointments

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
                    appointmentStatus: $0.analysisStatus
                )
            }
            combined.append(contentsOf: mappedAnalysis)

            return combined
        case .failure(let error):
            throw error
        }
    }
}
