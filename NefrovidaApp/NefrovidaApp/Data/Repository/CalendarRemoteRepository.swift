import Foundation
import Alamofire

final class RemoteAppointmentRepository: AppointmentRepository {

    private let baseURL = "http://10.25.98.27:3001"

    func fetchAppointments(forDate date: String, idUser: String) async throws -> [Appointment] {
        let endpoint = "\(baseURL)/api/users/appointments/\(idUser)"
        let request = AF.request(endpoint, method: .get).validate()
        let result = await request.serializingData().response

        switch result.result {
        case .success(let data):
            do {
                let response = try JSONDecoder().decode(AppointmentsResponse.self, from: data)

                // ✅ Combinar citas y análisis en un solo arreglo
                var combined: [Appointment] = []

                // 1️⃣ Agregar citas del día
                let filteredAppointments = response.appointments.filter {
                    $0.dateHour.starts(with: date)
                }
                combined.append(contentsOf: filteredAppointments)

                // 2️⃣ Agregar análisis del día (convertidos a Appointment)
                let filteredAnalysis = response.analysis.filter {
                    $0.analysisDate.starts(with: date)
                }
                let mappedAnalysis = filteredAnalysis.map {
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

                // 3️⃣ Devolver lista combinada
                return combined

            } catch {
                print("❌ Decoding error: \(error)")
                throw error
            }

        case .failure(let error):
            print("❌ Network error: \(error)")
            throw error
        }
    }
}
