import Foundation

public protocol AppointmentRepository {
    func fetchAppointments(forDate date: String) async throws -> [Appointment]
}
