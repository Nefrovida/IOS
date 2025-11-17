import Foundation

struct PostMessageUseCase {
    let repository: ForumRemoteRepository

    func execute(forumId: Int, content: String) async throws -> ForumMessageEntity {
        try await repository.postMessage(forumId: forumId, content: content)
    }
}
