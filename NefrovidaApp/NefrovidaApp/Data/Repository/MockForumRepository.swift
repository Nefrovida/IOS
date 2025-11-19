import Foundation

public final class MockForumRepository: ForumRepository {
    public init() {}

    public func fetchForums(page: Int? = nil, limit: Int? = nil, search: String? = nil, isPublic: Bool? = nil) async throws -> [Forum] {
        // Return 4 mock forums as per spec
        return (1...4).map { i in
            Forum(id: i, name: "Foro \(i)", description: "Foro para los pacientes de nefrovida", publicStatus: true, active: true, createdAt: Date())
        }
    }

    public func fetchMyForums() async throws -> [Forum] {
        return [Forum(id: 1, name: "Foro 1", description: "Foro para los pacientes de nefrovida", publicStatus: true, active: true, createdAt: Date())]
    }

    public func fetchForum(by id: Int) async throws -> (Forum, [Post]) {
        let forum = Forum(id: id, name: "Foro 1", description: "Foro para los pacientes de nefrovida", publicStatus: true, active: true, createdAt: Date())
        let posts = [
            Post(id: 1, content: "Hola pacientes de nefrovida", authorName: "Manuel Bajos", authorId: 101, createdAt: Date()),
            Post(id: 2, content: "Hola mucho texto para poder visualizar diferentes tamanos de pildora", authorName: "Juan Enrique Ayala Zapata", authorId: 102, createdAt: Date()),
            Post(id: 3, content: "Aqui les dejo el link: https://www.youtube.com/watch?v=dQw4w9WgXcQ", authorName: "Leonardo Cervantes", authorId: 103, createdAt: Date())
        ]
        return (forum, posts)
    }

    public func joinForum(id: Int) async throws -> Bool {
        // Simulate join success
        return true
    }

    // MARK: - Messages
    public func getMessages(forumId: Int) async throws -> [ForumMessageEntity] {
        // Return some mock messages
        return [
            ForumMessageEntity(id: 1, forumId: forumId, parentMessageId: nil, content: "Welcome to the mock forum!", createdBy: "Admin", createdAt: "2023-01-01T12:00:00Z"),
            ForumMessageEntity(id: 2, forumId: forumId, parentMessageId: 1, content: "Thanks for having me!", createdBy: "MockUser1", createdAt: "2023-01-01T12:05:00Z"),
            ForumMessageEntity(id: 3, forumId: forumId, parentMessageId: nil, content: "Any interesting topics today?", createdBy: "MockUser2", createdAt: "2023-01-01T13:00:00Z")
        ]
    }

    public func postMessage(forumId: Int, content: String) async throws -> ForumMessageEntity {
        // Simulate creating a new message
        return ForumMessageEntity(id: Int.random(in: 100...999), forumId: forumId, parentMessageId: nil, content: content, createdBy: "CurrentUser", createdAt: Date().ISO8601Format())
    }

    public func replyToMessage(forumId: Int, parentMessageId: Int, content: String) async throws -> ForumMessageEntity {
        // Simulate creating a new reply
        return ForumMessageEntity(id: Int.random(in: 100...999), forumId: forumId, parentMessageId: parentMessageId, content: content, createdBy: "CurrentUser", createdAt: Date().ISO8601Format())
    }
}
