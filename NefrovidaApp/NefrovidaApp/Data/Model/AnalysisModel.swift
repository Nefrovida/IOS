import Foundation

struct AnalysisResponse: Codable, Sendable {
    let success: Bool
    let message: String
    let data: [Analysis]
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
