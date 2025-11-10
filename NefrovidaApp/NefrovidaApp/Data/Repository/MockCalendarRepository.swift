//test 
public final class MockAppointmentRepository: AppointmentRepository {
    public init() {}

    public func fetchAppointments(forDate date: String) async throws -> [Appointment] {

        if date == "2025-11-05" {
            return [
                Appointment(doctorName: "Dr. A",
                            appointmentType: "Análisis",
                            studyName: "Biometría Hemática (BM)",
                            date: date, hour: "08:00")
            ]
        }

        if date == "2025-11-11" {
            return [
                Appointment(doctorName: "Dra. López",
                            appointmentType: "Consulta",
                            studyName: "Control mensual",
                            date: date, hour: "10:00")
            ]
        }
        
        if date == "2025-11-20" {
            return [
                Appointment(doctorName: "Dra. López",
                            appointmentType: "Consulta",
                            studyName: "Control mensual",
                            date: date, hour: "10:00")
            ]
        }

        return []
    }
}
