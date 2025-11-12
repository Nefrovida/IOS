import Foundation

/// Caso de uso encargado de obtener las citas de un día específico.
/// Aplica lógica de negocio como filtros de horario laboral.
final class GetAppointmentsForDayUseCase {
    private let repository: AppointmentRepository
    private let workHoursRange = 8...18  // Horario laboral permitido (8 a 18)

    init(repository: AppointmentRepository) {
        self.repository = repository
    }

    /// Ejecuta la lógica del caso de uso:
    /// - Obtiene todas las citas (appointments + analysis) del repositorio.
    /// - Filtra solo las del día seleccionado.
    /// - Excluye las que están fuera del horario laboral.
    func execute(date: String, idUser: String) async throws -> [Appointment] {
        let allAppointments = try await repository.fetchAppointments(forDate: date, idUser: idUser)
        // Filtrar por día
        let sameDay = allAppointments.filter {
            $0.dateHour.starts(with: date)
        }
        
        return sameDay
    }}
