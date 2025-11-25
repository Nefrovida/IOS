import Foundation

protocol GetRepliesUseCaseProtocol {
    func execute(forumId: Int, messageId: Int, page: Int?, limit: Int?) async throws -> [ForumMessageEntity]
}

class GetRepliesUseCase: GetRepliesUseCaseProtocol {
    private let repository: ForumRepository

    init(repository: ForumRepository) {
        self.repository = repository
    }

    func execute(forumId: Int, messageId: Int, page: Int? = 1, limit: Int? = 20) async throws -> [ForumMessageEntity] {
        return try await repository.fetchReplies(forumId: forumId, messageId: messageId, page: page, limit: limit)
    }
}
