import Foundation

// Use case responsible for retrieving all appointments scheduled for a specific day and user.
// It encapsulates the application logic for fetching appointments, delegating the data retrieval
// to an injected AppointmentRepository.
public final class GetAppointmentsForDayUseCase {
    
    // Reference to the repository abstraction (protocol) used to fetch appointment data.
    private let repository: AppointmentRepository
    
    // Initializes a new instance of the use case.
    // Parameter repository: An object conforming to `AppointmentRepository`,
    // injected through dependency inversion.
    // This allows flexibility to switch between remote or local data sources.
    public init(repository: AppointmentRepository) {
        self.repository = repository
    }

    // Executes the use case to retrieve all appointments for a specific date and user.
    // Parameters:
    // date: The target date for which to fetch appointments (format `"yyyy-MM-dd"`).
    // idUser: The identifier of the user whose appointments are being retrieved.
    // Returns: A list of `Appointment` domain entities.
    // Throws: Any error propagated from the repository (network failure, decoding issue, etc.).
    public func execute(date: String, idUser: String) async throws -> [Appointment] {
        try await repository.fetchAppointments(forDate: date, idUser: idUser)
    }
}
