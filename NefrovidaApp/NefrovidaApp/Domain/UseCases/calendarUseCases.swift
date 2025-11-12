import Foundation

// Caso de uso encargado de obtener las citas correspondientes a un día específico.
// Aplica reglas de negocio del dominio (por ejemplo, filtros o validaciones de horario laboral).
final class GetAppointmentsForDayUseCase {
    
    // Repositorio inyectado que provee los datos de las citas (ya sea remoto o local).
    private let repository: AppointmentRepository
    
    // Rango de horas laborales permitido (8:00 a 18:00).
    // Se puede usar para filtrar las citas fuera del horario de atención.
    private let workHoursRange = 8...18

    // Inicializador del caso de uso.
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
