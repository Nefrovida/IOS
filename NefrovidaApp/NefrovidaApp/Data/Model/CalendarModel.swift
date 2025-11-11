import Foundation
// Data Transfer Object (DTO) used to represent an appointment when sending or receiving data
// from a remote API. It allows the model to remain decoupled from
// network layer formats.
struct AppointmentDTO: Codable {

    let doctorName: String
    
    // Type of the appointment (e.g., "Consulta", "Análisis").
    let appointmentType: String
    
    let studyName: String
    
    let date: String   // "yyyy-MM-dd"
    
    //("08:30").
    let hour: String   // "HH:mm"

    // Converts the DTO (data layer model) into a domain-layer model used by the app logic.
    func toDomain() -> Appointment {
        Appointment(
            doctorName: doctorName,
            appointmentType: appointmentType,
            studyName: studyName,
            date: date,
            hour: hour
        )
    }
}
