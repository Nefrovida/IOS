import Foundation

struct ForumMessageEntity: Codable, Identifiable {
    let id: Int
    let forumId: Int
    let parentMessageId: Int?
    let content: String
    let createdBy: String
    let createdAt: String
}
