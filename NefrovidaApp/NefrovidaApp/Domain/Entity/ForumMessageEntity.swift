import Foundation

public struct ForumMessageEntity: Codable, Identifiable {
    public let id: Int
    public let forumId: Int?
    public let parentMessageId: Int?
    public let content: String
    public let createdBy: String
    public let createdAt: String?

    public init(id: Int, forumId: Int?, parentMessageId: Int?, content: String, createdBy: String, createdAt: String?) {
        self.id = id
        self.forumId = forumId
        self.parentMessageId = parentMessageId
        self.content = content
        self.createdBy = createdBy
        self.createdAt = createdAt
    }

    enum CodingKeys: String, CodingKey {
        case id
        case forumId = "forum_id"
        case parentMessageId = "parent_message_id"
        case content
        case createdBy = "created_by"
        case createdAt = "created_at"
    }
    
    // Helper struct for decoding nested author
    private struct AuthorDTO: Codable {
        let name: String
    }
    
    private enum AuthorKeys: String, CodingKey {
        case author
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        forumId = try container.decodeIfPresent(Int.self, forKey: .forumId)
        parentMessageId = try container.decodeIfPresent(Int.self, forKey: .parentMessageId)
        content = try container.decode(String.self, forKey: .content)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        
        // Try to decode 'created_by' directly
        if let directCreator = try? container.decode(String.self, forKey: .createdBy) {
            createdBy = directCreator
        } else {
            // Fallback to 'author' object
            let authorContainer = try decoder.container(keyedBy: AuthorKeys.self)
            if let author = try? authorContainer.decode(AuthorDTO.self, forKey: .author) {
                createdBy = author.name
            } else {
                createdBy = "Unknown"
            }
        }
    }
}
