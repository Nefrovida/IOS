import Foundation

public struct Forum: Identifiable, Hashable {
    public let id: Int
    public let name: String
    public let description: String
    public let publicStatus: Bool
    public let active: Bool
    public let createdAt: Date?
}

public struct Post: Identifiable {
    public let id: Int
    public let content: String
    public let authorName: String
    public let authorId: Int
    public let createdAt: Date?
}

public struct ForumFeedItem: Identifiable {
    public let id: Int
    public let forumId: Int
    public let content: String
    public var likes: Int
    public var replies: Int
    public let forumName: String
    public let authorName: String
    public var liked: Bool
}
