final class GetAppointmentsForDayUseCase {
    private let repository: AppointmentRepository
    
    init(repository: AppointmentRepository) {
        self.repository = repository
    }

    func execute(date: String, idUser: String) async throws -> [Appointment] {
        try await repository.fetchAppointments(forDate: date, idUser: idUser)
    }
}

