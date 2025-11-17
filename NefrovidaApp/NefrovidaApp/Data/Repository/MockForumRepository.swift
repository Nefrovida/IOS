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
}
