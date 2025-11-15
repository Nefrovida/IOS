import Foundation

// Main model representing a report fetched from the backend.
struct Report: Codable, Identifiable, Sendable {
    let id: Int
    let title: String?
    let specialty: String?
    let doctor: String?
    let date: String
    let recommendations: String?
    let treatment: String?
    let path: String
    let type: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case specialty
        case doctor
        case date
        case recommendations
        case treatment
        case path
        case type
    }
}
