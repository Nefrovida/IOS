import SwiftUI

struct ForumView: View {
    @StateObject private var vm: ForumViewModel
    let forumId: Int

    init(forumId: Int) {
        let repo = ForumRemoteRepository(baseURL: AppConfig.apiBaseURL)
        let getUC = GetMessagesUseCase(repository: repo)
        let postUC = PostMessageUseCase(repository: repo)
        let replyUC = ReplyToMessageUseCase(repository: repo)
        _vm = StateObject(wrappedValue: ForumViewModel(
            getMessagesUC: getUC,
            postMessageUC: postUC,
            replyToMessageUC: replyUC
        ))
        self.forumId = forumId
    }

    var body: some View {
        VStack(spacing: 0) {
            UpBar()

            // Message heriarchy
            List {
                ForEach(vm.messages.filter { $0.parentMessageId == nil }) { parent in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(parent.content)
                            .font(.body)

                        // nested responses
                        ForEach(vm.messages.filter { $0.parentMessageId == parent.id }) { reply in
                            HStack {
                                Spacer().frame(width: 20) // indentation
                                VStack(alignment: .leading) {
                                    Text(reply.content)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }

                        Button("Responder a este") {
                            vm.selectedParentMessageId = parent.id
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                }
            }

            // Field for new root message
            HStack {
                TextField("Escribe un mensaje...", text: $vm.newMessageContent)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Enviar") {
                    Task { await vm.sendMessage(forumId: forumId) }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()

            // Field for reply to selected message
            if vm.selectedParentMessageId != nil {
                HStack {
                    TextField("Escribe una respuesta...", text: $vm.replyContent)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Responder") {
                        Task { await vm.sendReply(forumId: forumId) }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }

        }
        .onAppear {
            Task { await vm.loadMessages(forumId: forumId) }
        }
    }
}

#Preview {
    ForumView(forumId: 1)
}
