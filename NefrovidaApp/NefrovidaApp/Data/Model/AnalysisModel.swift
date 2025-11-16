import Foundation

struct AnalysisResponse: Codable, Sendable {
    let success: Bool
    let message: String
    let data: [Analysis]
}

struct Consultation: Codable, Sendable {
    let appointmentId: Int
    let doctorId: String
    let nameConsultation: String
    let generalCost: Int
    let communityCost: Int
    let img: String?
    
    enum CodingKeys: String, CodingKey {
        case appointmentId = "appointment_id"
        case doctorId = "doctor_id"
        case nameConsultation = "name"
        case generalCost = "general_cost"
        case communityCost = "community_cost"
        case img = "image_url"
    }
}

struct Analysis: Codable, Identifiable, Sendable {
    let id: Int
    let name: String
    let description: String
    let previousRequirements: String
    let generalCost: String
    let communityCost: String

    enum CodingKeys: String, CodingKey {
        case id = "analysisId"
        case name
        case description
        case previousRequirements
        case generalCost
        case communityCost
    }
}
