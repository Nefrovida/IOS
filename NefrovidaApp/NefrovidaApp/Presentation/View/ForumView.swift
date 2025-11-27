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
                replyToMessageUC: ReplyToMessageUseCase(repository: repo),
                getRepliesUC: GetRepliesUseCase(repository: repo)
            )
        )

        self.forumId = forumId
        self.rootMessageId = rootMessageId
    }

    var body: some View {
        VStack(spacing: 0) {
            UpBar()

            // --- Replies list ---
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
            .listStyle(.plain)

            // --- Input bar ---
            HStack {
                TextField("Escribe una respuesta...", text: $vm.replyContent)
                    .textFieldStyle(.roundedBorder)

                Button("Enviar") {
                    Task {
                        await vm.sendReply(forumId: forumId, rootId: rootMessageId)
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .background(.ultraThinMaterial)
        }
        .task {
            await vm.loadThread(forumId: forumId, rootId: rootMessageId)
        }
        .navigationTitle("Respuestas")
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
