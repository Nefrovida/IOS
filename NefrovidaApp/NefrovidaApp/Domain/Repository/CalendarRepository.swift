import Foundation
// Protocol that defines the contract for fetching appointment data,
protocol AppointmentRepository {
    func fetchAppointments(forDate date: String, idUser: String) async throws -> [Appointment]
}
