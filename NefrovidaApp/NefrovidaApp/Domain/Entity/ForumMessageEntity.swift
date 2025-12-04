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
        case forumId
        case parentMessageId
        case content
        case createdBy
        case createdAt
        case publicationTimestamp
        case liked
        case stats
        case author
    }

    // LEGACY
    private enum LegacyCodingKeys: String, CodingKey {
        case forumId = "forum_id"
        case parentMessageId = "parent_message_id"
        case createdBy = "created_by"
        case createdAt = "created_at"
    }

    // MARK: - inner DTO

    private struct StatsDTO: Decodable {
        let repliesCount: Int
        let likesCount: Int
        
        enum CodingKeys: String, CodingKey {
            case repliesCount
            case likesCount
            // legacy
            case replies_count
            case likes_count
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            repliesCount =
                (try? container.decode(Int.self, forKey: .repliesCount)) ??
                (try? container.decode(Int.self, forKey: .replies_count)) ??
                0
            
            likesCount =
                (try? container.decode(Int.self, forKey: .likesCount)) ??
                (try? container.decode(Int.self, forKey: .likes_count)) ??
                0
        }
    }

    private struct AuthorDTO: Decodable {
        let name: String?
        let parentLastName: String?
        let maternalLastName: String?
        let username: String?
        
        enum CodingKeys: String, CodingKey {
            case name
            case parentLastName
            case maternalLastName
            // legacy
            case parent_last_name
            case maternal_last_name
            case username
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            name = try container.decodeIfPresent(String.self, forKey: .name)
            
            parentLastName =
                (try? container.decodeIfPresent(String.self, forKey: .parentLastName)) ??
                (try? container.decodeIfPresent(String.self, forKey: .parent_last_name))
            
            maternalLastName =
                (try? container.decodeIfPresent(String.self, forKey: .maternalLastName)) ??
                (try? container.decodeIfPresent(String.self, forKey: .maternal_last_name))
            
            username = try container.decodeIfPresent(String.self, forKey: .username)
        }
    }

    // MARK: - Main decode

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let legacyContainer = try? decoder.container(keyedBy: LegacyCodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        
        if let value = try? container.decodeIfPresent(Int.self, forKey: .forumId) {
            forumId = value
        } else if let legacy = legacyContainer,
                  let value = try? legacy.decodeIfPresent(Int.self, forKey: .forumId) {
            forumId = value
        } else {
            forumId = nil
        }
        
        if let value = try? container.decodeIfPresent(Int.self, forKey: .parentMessageId) {
            parentMessageId = value
        } else if let legacy = legacyContainer,
                  let value = try? legacy.decodeIfPresent(Int.self, forKey: .parentMessageId) {
            parentMessageId = value
        } else {
            parentMessageId = nil
        }
        
        content = try container.decode(String.self, forKey: .content)
        
        // createdAt:
        //  1) createdAt
        //  2) publicationTimestamp
        //  3) created_at
        if let value = try? container.decodeIfPresent(String.self, forKey: .createdAt) {
            createdAt = value
        } else if let value = try? container.decodeIfPresent(String.self, forKey: .publicationTimestamp) {
            createdAt = value
        } else if let legacy = legacyContainer,
                  let value = try? legacy.decodeIfPresent(String.self, forKey: .createdAt) {
            createdAt = value
        } else {
            createdAt = nil
        }
        
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
        
        // author / createdBy
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
            } else if let legacy = legacyContainer,
                      let rawCreator = try? legacy.decode(String.self, forKey: .createdBy) {
                createdBy = rawCreator
            } else {
                createdBy = "Usuario"
            }
        }
        else if let rawCreator = try? container.decode(String.self, forKey: .createdBy) {
            createdBy = rawCreator
        } else if let legacy = legacyContainer,
                  let rawCreator = try? legacy.decode(String.self, forKey: .createdBy) {
            createdBy = rawCreator
        } else {
            createdBy = "Usuario"
        }
    }
}
