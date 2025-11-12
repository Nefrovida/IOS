import Foundation

// Use case to obtain the appointments and return the appointment of a specific date.
final class GetAppointmentsForDayUseCase {
    
    // Repository to get the data.
    private let repository: AppointmentRepository
    
    // Range of the hour of work.
    private let workHoursRange = 8...18

    // Initial of the use case.
    // - Parameter repository: Implemention of the repository
    init(repository: AppointmentRepository) {
        self.repository = repository
    }

    // Get the appointments from the repository and apply a filter
    // Parameters: date: date of the appointment.
    // idUser: Id of the user in the sesion.
    // Returns: List of the appointment with the filter.
    // Throws: Error if the conection fails or the decode.
    func execute(date: String, idUser: String) async throws -> [Appointment] {
        // Get the appointment without filter.
        let allAppointments = try await repository.fetchAppointments(idUser: idUser)
        
        // Apply the filter with the date selected.
        let sameDay = allAppointments.filter {
            $0.dateHour.starts(with: date)
        }
        
        // Return the appointment of that selected date.
        return sameDay
    }
}
