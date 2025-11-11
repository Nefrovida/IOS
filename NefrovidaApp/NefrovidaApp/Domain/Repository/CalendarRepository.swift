import Foundation
// Protocol that defines the contract for fetching appointment data,
public protocol AppointmentRepository {
    
    // Fetches appointments for a given date and user.
    // Parameters: date: The target date for which to retrieve appointments,
    // idUser: The unique identifier of the user whose appointments should be fetched.
    // Returns: An array of `Appointment` domain models.
    // Throws: An error if the network request fails, data cannot be decoded,
    // or the repository encounters another issue.
    func fetchAppointments(forDate date: String, idUser: String) async throws -> [Appointment]
}
