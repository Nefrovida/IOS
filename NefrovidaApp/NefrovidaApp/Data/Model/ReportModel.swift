import Foundation


// Root response del endpoint
struct PatientReportsResponse: Decodable {
    let success: Bool
    let message: String
    let data: PatientReportsData
}

struct PatientReportsData: Decodable {
    let analysisResults: [AnalysisResult]
    let appointmentNotes: [AppointmentNote]
}

struct AnalysisResult: Decodable, Identifiable {
    var id: Int { resultId }

    let resultId: Int
    let patientAnalysisId: Int
    let date: String
    let path: String
    let interpretation: String?

    let patientAnalysis: PatientAnalysis
}

struct PatientAnalysis: Codable {
    let patientAnalysisId: Int
    let analysisDate: String?
    let resultsDate: String?
    let place: String
    let duration: Int
    let analysisStatus: String
    let analysis: AnalysisDetail
}

struct AnalysisDetail: Codable {
    let analysisId: Int
    let name: String
    let description: String
}


struct AppointmentNote: Decodable, Identifiable {

    // Identifiable → usar noteId
    var id: Int { noteId }

    let noteId: Int
    let patientAppointmentId: Int
    let patientId: String

    let title: String
    let content: String

    let ailments: String
    let generalNotes: String
    let prescription: String

    let visibility: Bool
    let createdAt: String

    let appointment: AppointmentReportInfo
}

// Relación con la cita
struct AppointmentReportInfo: Decodable {
    let appointmentId: Int
    let date: String
    let duration: Int
    let type: String
    let place: String?
    let status: String
}
