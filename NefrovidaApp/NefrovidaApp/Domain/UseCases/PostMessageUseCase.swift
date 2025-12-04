import Foundation

struct PostMessageUseCase {
    let repository: ForumRepository

    func execute(forumId: Int, content: String) async throws -> Bool {
        try await repository.postMessage(forumId: forumId, content: content)
    }
}
