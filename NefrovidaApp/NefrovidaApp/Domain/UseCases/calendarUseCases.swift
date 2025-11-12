import Foundation

// Use case to obtain the appointments and return the appointment of a specific date.
final class GetAppointmentsForDayUseCase {
    
    // Repository to get the data.
    private let repository: AppointmentRepository
    
    // Range of the hour of work.
    private let workHoursRange = 8...18

    // Initial of the use case.
    // - Parameter repository: Implementación concreta del repositorio (por ejemplo, RemoteAppointmentRepository).
    init(repository: AppointmentRepository) {
        self.repository = repository
    }

    // Ejecuta la lógica principal del caso de uso.
    // - Obtiene todas las citas del repositorio (incluye citas médicas y análisis).
    // - Filtra únicamente las citas correspondientes al día indicado.
    // - En esta versión, no se aplica aún el filtro por horario laboral.
    //
    // - Parameters:
    //   - date: Fecha que se desea consultar en formato "yyyy-MM-dd".
    //   - idUser: Identificador único del usuario autenticado.
    // - Returns: Lista filtrada de citas del día.
    // - Throws: Propaga errores de red o de decodificación ocurridos en el repositorio.
    func execute(date: String, idUser: String) async throws -> [Appointment] {
        // Solicita todas las citas del repositorio (sin filtrar).
        let allAppointments = try await repository.fetchAppointments(idUser: idUser)
        
        // Filtra únicamente las citas cuya fecha (dateHour) comience con la fecha seleccionada.
        let sameDay = allAppointments.filter {
            $0.dateHour.starts(with: date)
        }
        
        // Retorna solo las citas del día solicitado.
        return sameDay
    }
}
