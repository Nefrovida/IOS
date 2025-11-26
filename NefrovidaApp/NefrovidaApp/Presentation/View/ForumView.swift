import SwiftUI

struct ForumView: View {
    @StateObject private var vm: ForumViewModel
    let forumId: Int
    let rootMessageId: Int

    init(forumId: Int, rootMessageId: Int) {
        let repo = ForumRemoteRepository(baseURL: AppConfig.apiBaseURL, tokenProvider: AppConfig.tokenProvider)

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

            List {
                ForEach(vm.messages.filter { $0.parentMessageId == nil }) { parent in
                    VStack(alignment: .leading) {
                        Text(parent.content)
                            .font(.body)

                        // replies
                        ForEach(vm.messages.filter { $0.parentMessageId == parent.id }) { reply in
                            Text(reply.content)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.leading, 20)
                        }
                    }
                    .task {
                        await vm.fetchReplies(forumId: forumId, messageId: parent.id)
                    }
                }
            }
        }
        .onAppear {
            Task { await vm.loadMessages(forumId: forumId) }
        }
        .navigationTitle("Respuestas")
    }
}

#Preview { ForumView(forumId: 1, rootMessageId: 1) }
