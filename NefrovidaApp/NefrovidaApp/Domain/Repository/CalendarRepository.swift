import Foundation

// Protocol that specify what the repository need to implement.

protocol AppointmentRepository {
    // Method that get the appointments depending of the userid.
    // Parameters: idUser: Id of the user in the sesion.
    // Returns: Array of the appointments and analysis.
    // Throws: Error if the conection fails or the decode.
    func fetchAppointments(idUser: String) async throws -> [Appointment]
}
