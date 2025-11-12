import Foundation

// Struct that represent the JSON of the API.
struct AppointmentsResponse: Codable {
    // Array of the appointment.
    let appointments: [Appointment]
    // Array of the analysis.
    let analysis: [AnalysisDTO]
}

// Struct that represent a individual appointment.
struct Appointment: Codable {
    // ID of the appointment of the patient.
    let patientAppointmentId: Int
    let patientId: String
    let appointmentId: Int
    let dateHour: String
    let duration: Int
    let appointmentType: String
    let link: String?
    let place: String?
    let appointmentStatus: String

    // Map the values of the json with the struct if the name are differents.
    enum CodingKeys: String, CodingKey {
        case patientAppointmentId = "patient_appointment_id"
        case patientId = "patient_id"
        case appointmentId = "appointment_id"
        case dateHour = "date_hour"
        case duration
        case appointmentType = "appointment_type"
        case link
        case place
        case appointmentStatus = "appointment_status"
    }
}


// Extension to use the model inside of the AgendaList.
extension Appointment: Identifiable {
    // Se usa el identificador único de la cita del paciente como `id`.
    var id: Int { patientAppointmentId }
}


// Struct that represent a individual analysis.
struct AnalysisDTO: Codable {
    // Id of the analysis of the patient.
    let patientAnalysisId: Int
    // Id of the person who do the analysis.
    let laboratoristId: String
    // Id of the type of the analysis.
    let analysisId: Int
    let patientId: String
    let analysisDate: String
    let resultsDate: String
    let place: String
    let duration: Int
    let analysisStatus: String

    // Map of the struct and the json
    enum CodingKeys: String, CodingKey {
        case patientAnalysisId = "patient_analysis_id"
        case laboratoristId = "laboratorist_id"
        case analysisId = "analysis_id"
        case patientId = "patient_id"
        case analysisDate = "analysis_date"
        case resultsDate = "results_date"
        case place, duration
        case analysisStatus = "analysis_status"
    }
}
