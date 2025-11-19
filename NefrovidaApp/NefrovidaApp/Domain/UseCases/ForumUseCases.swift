import Foundation

public final class GetForumsUseCase {
    private let repository: ForumRepository
    public init(repository: ForumRepository) { self.repository = repository }

    public func execute(page: Int? = nil, limit: Int? = nil, search: String? = nil, isPublic: Bool? = nil) async throws -> [Forum] {
        try await repository.fetchForums(page: page, limit: limit, search: search, isPublic: isPublic)
    }
}

public final class GetMyForumsUseCase {
    private let repository: ForumRepository
    public init(repository: ForumRepository) { self.repository = repository }
    public func execute() async throws -> [Forum] {
        try await repository.fetchMyForums()
    }
}

public final class GetForumDetailsUseCase {
    private let repository: ForumRepository
    public init(repository: ForumRepository) { self.repository = repository }
    public func execute(forumId: Int) async throws -> (Forum, [Post]) {
        try await repository.fetchForum(by: forumId)
    }
}

public final class JoinForumUseCase {
    private let repository: ForumRepository
    public init(repository: ForumRepository) { self.repository = repository }
    public func execute(forumId: Int) async throws -> Bool {
        try await repository.joinForum(id: forumId)
    }
}
