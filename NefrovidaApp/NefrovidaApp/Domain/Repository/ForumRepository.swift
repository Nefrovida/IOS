import Foundation

public protocol ForumRepository {
    func fetchForums(page: Int?, limit: Int?, search: String?, isPublic: Bool?) async throws -> [Forum]
    func fetchMyForums() async throws -> [Forum]
    func fetchForum(by id: Int) async throws -> (Forum, [Post])
    func joinForum(id: Int) async throws -> Bool
}
