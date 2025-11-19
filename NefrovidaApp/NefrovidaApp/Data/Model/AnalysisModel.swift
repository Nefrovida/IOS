import Foundation

//Model used to decode the API response for the list of analyses.
//The API returns a JSON object with `success`, `message`, and `data` (which contains the list).
struct AnalysisResponse: Codable, Sendable {
    let success: Bool        // Indicates whether the request was successful
    let message: String      // Descriptive message from the API
    let data: [Analysis]     // List of analysis items returned by the server
}

// Model used to decode the API response for consultations.
// Similar to `AnalysisResponse`, but maps a list of `Consultation`.
struct ConsultationResponse: Codable, Sendable {
    let success: Bool
    let message: String
    let data: [Consultation]
}

// Represents a medical consultation (appointment).
// Conforms to `Codable` for data decoding and `Sendable` for safe use with concurrency.
struct Consultation: Codable, Sendable {
    let appointmentId: Int          // Unique ID of the appointment
    let doctorId: String            // ID of the doctor leading the consultation
    let nameConsultation: String    // Title or name of the consultation
    let generalCost: Int            // General cost (for external clients)
    let communityCost: Int          // Special cost for community members
    let img: String?                // Optional URL string for an associated image

    // Maps JSON keys from snake_case to Swift camelCase properties.
    enum CodingKeys: String, CodingKey {
        case appointmentId = "appointment_id"
        case doctorId = "doctor_id"
        case nameConsultation = "name"
        case generalCost = "general_cost"
        case communityCost = "community_cost"
        case img = "image_url"
    }
}

// Adds `Identifiable` conformance to `Consultation` so it can be easily used in SwiftUI lists.
// The `appointmentId` is used as the unique identifier.
extension Consultation: Identifiable {
    var id: Int { appointmentId }
}

// Represents a lab test or analysis.
// Conforms to `Codable` for decoding and `Identifiable` for SwiftUI.
struct Analysis: Codable, Identifiable, Sendable {
    let id: Int                     // Unique ID of the analysis
    let name: String                // Name of the analysis
    let description: String         // A short description of the test
    let previousRequirements: String// Requirements before taking the test (e.g., fasting)
    let generalCost: String         // Cost for external users (as a string, per backend)
    let communityCost: String       // Cost for community members (string)

    // Maps JSON keys from snake_case to Swift camelCase properties.
    enum CodingKeys: String, CodingKey {
        case id = "analysisId"
        case name
        case description
        case previousRequirements
        case generalCost
        case communityCost
    }
}
