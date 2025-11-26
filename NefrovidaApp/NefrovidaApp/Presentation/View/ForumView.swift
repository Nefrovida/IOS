import SwiftUI

struct ForumView: View {
    @StateObject private var vm: ForumViewModel
    let forumId: Int

    init(forumId: Int) {
        let repo: ForumRepository
        if AppConfig.useRemoteForums {
            repo = ForumRemoteRepository(baseURL: AppConfig.apiBaseURL, tokenProvider: AppConfig.tokenProvider)
        } else {
            repo = MockForumRepository()
        }
        
        let getUC = GetMessagesUseCase(repository: repo as! ForumRemoteRepository)
        let postUC = PostMessageUseCase(repository: repo as! ForumRemoteRepository)
        let replyUC = ReplyToMessageUseCase(repository: repo as! ForumRemoteRepository)
        let getDetailsUC = GetForumDetailsUseCase(repository: repo)
        let getRepliesUC = GetRepliesUseCase(repository: repo)
        
        _vm = StateObject(wrappedValue: ForumViewModel(
            getMessagesUC: getUC,
            postMessageUC: postUC,
            replyToMessageUC: replyUC,
            getForumDetailsUC: getDetailsUC,
            getRepliesUC: getRepliesUC
        ))
        self.forumId = forumId
    }

    var body: some View {
        VStack(spacing: 0) {
            UpBar()
            
            if vm.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let err = vm.errorMessage {
                VStack(spacing: 10) {
                    Text(err).foregroundStyle(.red)
                    Button("Reintentar") {
                        Task { await vm.loadMessages(forumId: forumId) }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // Forum Title
                Text(vm.forum?.name ?? "Foro")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
                
                // Message heriarchy
                List {
                    if vm.messages.isEmpty {
                        Text("Aun no hay mensajes en este foro")
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    } else {
                        ForEach(vm.messages.filter { $0.parentMessageId == nil }) { parent in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(parent.content)
                                    .font(.body)
                                
                                // nested responses
                                ForEach(vm.messages.filter { $0.parentMessageId == parent.id }) { reply in
                                    VStack {
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
                            .task {
                                await vm.fetchReplies(forumId: forumId, messageId: parent.id)
                            }
                        }
                    }
                }
                
                // Field for reply to selected message
                if vm.selectedParentMessageId == nil {
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
                } else {
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

        }
        .onAppear {
            Task { await vm.loadMessages(forumId: forumId) }
        }
    }
}

#Preview {
    ForumView(forumId: 1)
}
