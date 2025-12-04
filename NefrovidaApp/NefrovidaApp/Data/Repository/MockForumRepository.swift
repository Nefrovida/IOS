
import Foundation


public final class MockForumRepository: ForumRepository {
    
    public init() {}
    
    // MARK: - Feed
    
    public func getFeed(forumId: Int?, page: Int) async throws -> [ForumFeedItem] {
        return [
            ForumFeedItem(
                id: 1,
                forumId: forumId ?? 1,
                content: "Bienvenidos al foro de prueba",
                likes: 3,
                replies: 1,
                forumName: "Foro mock",
                authorName: "Dr. Mock",
                liked: false
            ),
            ForumFeedItem(
                id: 2,
                forumId: forumId ?? 1,
                content: "Recuerden hidratarse y tomar sus medicamentos a tiempo.",
                likes: 10,
                replies: 4,
                forumName: "Foro mock",
                authorName: "Enfermera Demo",
                liked: true
            )
        ]
    }
    
    // MARK: - Forums
    
    public func fetchForums(
        page: Int? = nil,
        limit: Int? = nil,
        search: String? = nil,
        isPublic: Bool? = nil
    ) async throws -> [Forum] {
        return (1...4).map { i in
            Forum(
                id: i,
                name: "Foro \(i)",
                description: "Foro para los pacientes de nefrovida",
                publicStatus: true,
                active: true,
                createdAt: Date()
            )
        }
    }
    
    public func fetchMyForums() async throws -> [Forum] {
        return [
            Forum(
                id: 1,
                name: "Foro 1",
                description: "Foro para los pacientes de nefrovida",
                publicStatus: true,
                active: true,
                createdAt: Date()
            )
        ]
    }
    
    public func fetchForum(by id: Int) async throws -> (Forum, [Post]) {
        let forum = Forum(
            id: id,
            name: "Foro 1",
            description: "Foro para los pacientes de nefrovida",
            publicStatus: true,
            active: true,
            createdAt: Date()
        )
        
        let posts = [
            Post(
                id: 1,
                content: "Hola pacientes de nefrovida",
                authorName: "Manuel Bajos",
                authorId: 101,
                createdAt: Date()
            ),
            Post(
                id: 2,
                content: "Hola, mucho texto para poder visualizar diferentes tamaños de píldora",
                authorName: "Juan Enrique Ayala Zapata",
                authorId: 102,
                createdAt: Date()
            ),
            Post(
                id: 3,
                content: "Aquí les dejo el link: https://www.youtube.com/watch?v=dQw4w9WgXcQ",
                authorName: "Leonardo Cervantes",
                authorId: 103,
                createdAt: Date()
            )
        ]
        return (forum, posts)
    }
    
    public func joinForum(id: Int) async throws -> Bool {
        // Simulate join success
        return true
    }
    
    // MARK: - Likes
    
    public func toggleLike(messageId: Int) async throws {
    }
    
    // MARK: - Messages
    public func getMessages(forumId: Int) async throws -> [ForumMessageEntity] {
        // Return some mock messages
        return [
            ForumMessageEntity(
                id: 1,
                forumId: forumId,
                parentMessageId: nil,
                content: "Welcome to the mock forum!",
                createdBy: "Admin",
                createdAt: "2023-01-01T12:00:00Z",
                liked: false,
                likesCount: 2,
                repliesCount: 1
            ),
            ForumMessageEntity(
                id: 2,
                forumId: forumId,
                parentMessageId: nil,
                content: "Este es otro mensaje de ejemplo",
                createdBy: "MockUser1",
                createdAt: "2023-01-01T13:00:00Z",
                liked: true,
                likesCount: 5,
                repliesCount: 0
            )
        ]
    }

    public func postMessage(forumId: Int, content: String) async throws -> Bool {
        // Simulate creating a new message - just return success
        return true
    }
    
    public func replyToMessage(
        forumId: Int,
        parentMessageId: Int,
        content: String
    ) async throws -> ForumMessageEntity {
        // Simula creación de una respuesta
        return ForumMessageEntity(
            id: Int.random(in: 100...999),
            forumId: forumId,
            parentMessageId: parentMessageId,
            content: content,
            createdBy: "CurrentUser",
            createdAt: Date().ISO8601Format(),
            liked: false,
            likesCount: 0,
            repliesCount: 0
        )
    }
    
    public func fetchReplies(
        forumId: Int,
        messageId: Int,
        page: Int?,
        limit: Int?
    ) async throws -> [ForumMessageEntity] {
        return [
            ForumMessageEntity(
                id: Int.random(in: 1000...9999),
                forumId: forumId,
                parentMessageId: messageId,
                content: "This is a mock reply",
                createdBy: "MockUser",
                createdAt: Date().ISO8601Format(),
                liked: false,
                likesCount: 0,
                repliesCount: 0
            )
        ]
    }
}


