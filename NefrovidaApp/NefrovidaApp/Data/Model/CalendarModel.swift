import Foundation

// Struct that represent the JSON of the API.
struct AppointmentsResponse: Codable {
    // Array of the appointment.
    let appointments: [Appointment]
    // Array of the analysis.
    let analysis: [AnalysisDTO]
}

// Struct that represent an individual appointment.
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

    //  Name of the appointment (example: "consulta general")
    let appointmentInfo: AppointmentInfo?

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
        case appointmentInfo = "appointment"
    }
}

// Model for the appointment details: { "name": "Consulta general" }
struct AppointmentInfo: Codable {
    let name: String
}

// Extension to use the model inside of the AgendaList.
extension Appointment: Identifiable {
    var id: Int { patientAppointmentId }
}

// Struct that represent a individual analysis.
struct AnalysisDTO: Codable {
    let patientAnalysisId: Int
    let laboratoristId: String?
    let analysisId: Int
    let patientId: String
    let analysisDate: String
    let resultsDate: String?
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

extension Appointment {
    var localDate: Date {
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        iso.timeZone = TimeZone(secondsFromGMT: 0)

        return iso.date(from: dateHour) ?? Date()
    }

    var localHourString: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "America/Mexico_City")
        formatter.locale = Locale(identifier: "es_MX")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: localDate)
    }

    var localHourInt: Int {
        Int(localHourString.prefix(2)) ?? 0
    }
}
