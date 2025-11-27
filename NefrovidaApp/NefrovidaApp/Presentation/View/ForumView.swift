import SwiftUI

struct ForumView: View {
    @StateObject private var vm: ForumViewModel
    let forumId: Int
    let rootMessageId: Int

    init(forumId: Int, rootMessageId: Int) {
        let repo = ForumRemoteRepository(
            baseURL: AppConfig.apiBaseURL,
            tokenProvider: AppConfig.tokenProvider
        )

        _vm = StateObject(
            wrappedValue: ForumViewModel(
                getMessagesUC: GetMessagesUseCase(repository: repo),
                postMessageUC: PostMessageUseCase(repository: repo),
                replyToMessageUC: ReplyToMessageUseCase(repository: repo),
                getForumDetailsUC: GetForumDetailsUseCase(repository: repo),
                getRepliesUC: GetRepliesUseCase(repository: repo)
            )
        )
        
        self.forumId = forumId
        self.rootMessageId = rootMessageId
    }

    var body: some View {
        VStack(spacing: 0) {
            UpBar()

            List(vm.messages) { reply in
                VStack(alignment: .leading, spacing: 6) {
                    Text(reply.createdBy)
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text(reply.content)
                        .font(.body)
                }
                .padding(.vertical, 6)
            }
        }
        .task {
            await vm.loadMessages(forumId: forumId, rootId: rootMessageId)
        }
        .navigationTitle("Respuestas")
    }
}
