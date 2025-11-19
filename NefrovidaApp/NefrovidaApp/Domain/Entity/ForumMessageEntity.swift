import Foundation

public struct ForumMessageEntity: Codable, Identifiable {
    public let id: Int
    public let forumId: Int
    public let parentMessageId: Int?
    public let content: String
    public let createdBy: String
    public let createdAt: String

    public init(id: Int, forumId: Int, parentMessageId: Int?, content: String, createdBy: String, createdAt: String) {
        self.id = id
        self.forumId = forumId
        self.parentMessageId = parentMessageId
        self.content = content
        self.createdBy = createdBy
        self.createdAt = createdAt
    }
}
