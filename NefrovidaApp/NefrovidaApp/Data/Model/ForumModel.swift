//
//  ForumModel.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 23/11/25.
//
import Foundation

struct FeedDTO: Codable {
    let messageId: Int
    let content: String
    let likes: Int
    let replies: Int
    let forums: ForumFeedInfoDTO
}

struct ForumFeedInfoDTO: Codable {
    let forumId: Int
    let name: String
}

extension FeedDTO {
    func toDomain() -> ForumFeedItem {
        ForumFeedItem(
            id: messageId,
            content: content,
            likes: likes,
            replies: replies,
            forumName: forums.name
        )
    }
}
