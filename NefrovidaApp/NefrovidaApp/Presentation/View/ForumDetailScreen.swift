import SwiftUI

struct ForumDetailScreen: View {
    @StateObject private var vm: ForumDetailViewModel

    init(forumId: Int) {
        let repo: ForumRepository
        if AppConfig.useRemoteForums {
            repo = RemoteForumRepository(baseURL: AppConfig.apiBaseURL, tokenProvider: AppConfig.tokenProvider)
        } else {
            repo = MockForumRepository()
        }
        let detailsUC = GetForumDetailsUseCase(repository: repo)
        let joinUC = JoinForumUseCase(repository: repo)
        _vm = StateObject(wrappedValue: ForumDetailViewModel(forumId: forumId, getForumDetailsUC: detailsUC, joinForumUC: joinUC))
    }

    var body: some View {
        VStack(spacing: 0) {
            UpBar()

            Text(vm.forum?.name ?? "Foro")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding(.top, 8)

            if vm.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let err = vm.errorMessage {
                VStack(spacing: 10) {
                    Text(err).foregroundStyle(.red)
                    Button("Reintentar") { vm.onAppear() }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                if vm.posts.isEmpty {
                    Text("Aun no hay mensajes en este foro")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, minHeight: 240)
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(vm.posts) { post in
                                PostCard(post: post).padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }

            BottomBar()
        }
        .onAppear { vm.onAppear() }
    }
}

#Preview {
    ForumDetailScreen(forumId: 1)
}
