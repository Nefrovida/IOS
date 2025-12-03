import Foundation

struct GetMessagesUseCase {
    let repository: ForumRepository

    func execute(forumId: Int) async throws -> [ForumMessageEntity] {
        try await repository.getMessages(forumId: forumId)
    }
}
