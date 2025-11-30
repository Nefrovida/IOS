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
            if vm.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = vm.errorMessage {
                VStack(spacing: 8) {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                    Button("Reintentar") {
                        Task {
                            await vm.loadThread(forumId: forumId, rootId: rootMessageId)
                        }
                    }
                    .buttonStyle(.bordered)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if vm.messages.isEmpty {
                Text("Aún no hay respuestas en este hilo")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
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
            }
        }
        // --- Input bar ---
        .safeAreaInset(edge: .bottom) {
            HStack {
                TextField("Escribe una respuesta...", text: $vm.replyContent, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(1...3)

                Button("Enviar") {
                    Task {
                        await vm.sendReply(forumId: forumId, rootId: rootMessageId)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(
                    vm.replyContent
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .isEmpty || vm.isLoading
                )
                .opacity(
                    vm.replyContent
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .isEmpty || vm.isLoading ? 0.6 : 1
                )
            }
            .padding()
            .background(.ultraThinMaterial)
        }
        .task {
            await vm.loadThread(forumId: forumId, rootId: rootMessageId)
        }
        .navigationTitle("Respuestas")
        .navigationBarTitleDisplayMode(.inline)
    }
}
