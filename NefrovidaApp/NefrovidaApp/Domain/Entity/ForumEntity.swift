import Foundation

public struct Forum: Identifiable {
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
