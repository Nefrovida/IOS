import Foundation

struct ReplyToMessageUseCase {
    let repository: ForumRemoteRepository

    func execute(forumId: Int, parentMessageId: Int, content: String) async throws -> ForumMessageEntity {
        try await repository.replyToMessage(forumId: forumId, parentMessageId: parentMessageId, content: content)
    }
}
