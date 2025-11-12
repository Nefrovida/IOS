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
                
                // Filtrar solo las citas del día seleccionado
                let filtered = response.appointments.filter {
                    $0.dateHour.starts(with: date)
                }

                // ✅ Ya no hay conversión, porque Appointment es el modelo real
                return filtered
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
