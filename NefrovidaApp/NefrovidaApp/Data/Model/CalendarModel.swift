import Foundation

// MARK: - Response raíz
struct AppointmentsResponse: Codable {
    let appointments: [Appointment]
    let analysis: [AnalysisDTO]
}

// MARK: - AppointmentDTO (coincide con el JSON del backend)
struct Appointment: Codable {
    let patientAppointmentId: Int
    let patientId: String
    let appointmentId: Int
    let dateHour: String
    let duration: Int
    let appointmentType: String
    let link: String?
    let place: String?
    let appointmentStatus: String

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

extension Appointment: Identifiable {
    var id: Int { patientAppointmentId }
}

// MARK: - AnalysisDTO (coincide con el JSON del backend)
struct AnalysisDTO: Codable {
    let patientAnalysisId: Int
    let laboratoristId: String
    let analysisId: Int
    let patientId: String
    let analysisDate: String
    let resultsDate: String
    let place: String
    let duration: Int
    let analysisStatus: String

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
