//
//  ForumModel.swift
//  NefrovidaApp
//  Created by Manuel Bajos Rivera on 23/11/25.
//
import Foundation

struct FeedDTO: Decodable {
    let messageId: Int
    let content: String
    let likes: Int
    let replies: Int
    let forums: ForumFeedInfoDTO
    let userName: String?
    let liked: Int?
}

struct ForumFeedInfoDTO: Decodable {
    let forumId: Int
    let name: String
}

extension FeedDTO {
    func toDomain() -> ForumFeedItem {
        ForumFeedItem(
            id: messageId,
            forumId: forums.forumId,
            content: content,
            likes: likes,
            replies: replies,
            forumName: forums.name,
            authorName: userName ?? "Usuario",
            liked: (liked ?? 0) == 1
        )
        
    }
}
    
        // MARK: - Forum Message (Post)
struct ForumMessage: Identifiable, Codable {
    let id: Int
    let forumId: Int
    let forumName: String
    let userId: String
    let userName: String?
    let userAvatar: String?
    let content: String
    let timestampPublish: Date
    let likesCount: Int
    let commentsCount: Int
    let active: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "message_id"
        case forumId = "forum_id"
        case forumName = "forum_name"
        case userId = "user_id"
        case userName = "user_name"
        case userAvatar = "user_avatar"
        case content
        case timestampPublish = "timestamp_publish"
        case likesCount = "likes_count"
        case commentsCount = "comments_count"
        case active
    }
    
    var truncatedContent: String {
        let maxLength = 200
        if content.count > maxLength {
            return String(content.prefix(maxLength)) + "..."
        }
        return content
    }
    
    var relativeTime: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.locale = Locale(identifier: "es")
        return formatter.localizedString(for: timestampPublish, relativeTo: Date())
    }
}
        
// MARK: - New Message Request
struct CreateMessageRequest: Codable {
    let message: String
}
        
// MARK: - Message Response
struct MessageResponse: Codable {
    let message: String
}
        
        // MARK: - Messages Feed Response
struct MessagesFeedResponse: Codable {
    let messages: [ForumMessage]
    let hasMore: Bool
    let nextPage: Int?
    
    enum CodingKeys: String, CodingKey {
        case messages
        case hasMore = "has_more"
        case nextPage = "next_page"
    }
}

