import Foundation

public struct ForumMessageEntity: Decodable, Identifiable {
    public let id: Int
    public let forumId: Int?
    public let parentMessageId: Int?
    public let content: String
    public let createdBy: String
    public let createdAt: String?

    public var liked: Bool
    public var likesCount: Int
    public var repliesCount: Int
    
    public init(
        id: Int,
        forumId: Int?,
        parentMessageId: Int?,
        content: String,
        createdBy: String,
        createdAt: String?,
        liked: Bool = false,
        likesCount: Int = 0,
        repliesCount: Int = 0
    ) {
        self.id = id
        self.forumId = forumId
        self.parentMessageId = parentMessageId
        self.content = content
        self.createdBy = createdBy
        self.createdAt = createdAt
        self.liked = liked
        self.likesCount = likesCount
        self.repliesCount = repliesCount
    }

    enum CodingKeys: String, CodingKey {
        case id
        case forumId = "forum_id"
        case parentMessageId = "parent_message_id"
        case content
        case createdBy = "created_by"
        case createdAt = "created_at"
        case liked
        case stats
        case author
    }

    private struct StatsDTO: Codable {
        let repliesCount: Int
        let likesCount: Int
        
        enum CodingKeys: String, CodingKey {
            case repliesCount = "replies_count"
            case likesCount   = "likes_count"
        }
    }

    private struct AuthorDTO: Codable {
        let name: String?
        let parentLastName: String?
        let maternalLastName: String?
        let username: String?
        
        enum CodingKeys: String, CodingKey {
            case name
            case parentLastName   = "parent_last_name"
            case maternalLastName = "maternal_last_name"
            case username
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        forumId = try container.decodeIfPresent(Int.self, forKey: .forumId)
        parentMessageId = try container.decodeIfPresent(Int.self, forKey: .parentMessageId)
        content = try container.decode(String.self, forKey: .content)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        
        if let likedInt = try? container.decode(Int.self, forKey: .liked) {
            liked = likedInt != 0
        } else if let likedBool = try? container.decode(Bool.self, forKey: .liked) {
            liked = likedBool
        } else {
            liked = false
        }
        
        if let stats = try? container.decode(StatsDTO.self, forKey: .stats) {
            repliesCount = stats.repliesCount
            likesCount = stats.likesCount
        } else {
            repliesCount = 0
            likesCount = 0
        }
        
        if let author = try? container.decode(AuthorDTO.self, forKey: .author) {
            let parts = [
                author.name,
                author.parentLastName,
                author.maternalLastName
            ]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            
            if !parts.isEmpty {
                createdBy = parts.joined(separator: " ")
            } else if let username = author.username, !username.isEmpty {
                createdBy = username
            } else if let rawCreator = try? container.decode(String.self, forKey: .createdBy) {
                createdBy = rawCreator
            } else {
                createdBy = "Usuario"
            }
        }
        else if let rawCreator = try? container.decode(String.self, forKey: .createdBy) {
            createdBy = rawCreator
        } else {
            createdBy = "Usuario"
        }
    }
}
