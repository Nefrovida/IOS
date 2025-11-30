import SwiftUI

struct ForumView: View {
    @StateObject private var vm: ForumViewModel
    let forumId: Int
    let rootMessageId: Int

    @FocusState private var isInputFocused: Bool
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
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture { isInputFocused = false }

            } else {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 0) {
                            ForEach(vm.messages) { reply in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(reply.createdBy)
                                        .font(.caption)
                                        .foregroundColor(.secondary)

                                    Text(reply.content)
                                        .font(.body)
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal)
                                .id(reply.id)

                                Divider()
                                    .padding(.leading)
                            }
                        }
                        .padding(.bottom, isInputFocused ? 80 : 0)
                    }
                    .onAppear {
                        guard let last = vm.messages.last else { return }
                        DispatchQueue.main.async {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                    .onChange(of: vm.messages.count) { _ in
                        guard let last = vm.messages.last else { return }
                        DispatchQueue.main.async {
                            withAnimation {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                    .simultaneousGesture(
                        TapGesture().onEnded { isInputFocused = false }
                    )
                }
            }
        }
        // --- Input bar ---
        .safeAreaInset(edge: .bottom) {
            HStack {
                TextField(
                    "Escribe una respuesta...",
                    text: $vm.replyContent,
                    axis: .vertical
                )
                .textFieldStyle(.roundedBorder)
                .lineLimit(1...3)
                .focused($isInputFocused)

                Button("Enviar") {
                    Task {
                        await vm.sendReply(forumId: forumId, rootId: rootMessageId)
                        await MainActor.run {
                            isInputFocused = false
                        }
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
