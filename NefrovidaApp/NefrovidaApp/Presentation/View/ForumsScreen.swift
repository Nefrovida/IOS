import SwiftUI

enum MessageRoute: Hashable {
    case feed(forum: Forum)
    case replies(forumId: Int, messageId: Int)
}

struct ForumsScreen: View {
    @StateObject private var vm: ForumsViewModel
    @State private var path: [MessageRoute] = []

    init() {
        let repo: ForumRepository
        if AppConfig.useRemoteForums {
            repo = ForumRemoteRepository(baseURL: AppConfig.apiBaseURL)
        } else {
            repo = MockForumRepository()
        }
        _vm = StateObject(
            wrappedValue: ForumsViewModel(
                getForumsUC: GetForumsUseCase(repository: repo),
                getMyForumsUC: GetMyForumsUseCase(repository: repo),
                joinForumUC: JoinForumUseCase(repository: repo)
            ))
    }

    var body: some View {
        NavigationStack(path: $path) {
            
            VStack(spacing: 0) {
                UpBar()

                Text("Tus Foros")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 8)

                if vm.isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(vm.forums) { forum in
                                ForumCard(forum: forum, isMember: vm.isMember(of: forum)) {
                                    Task {
                                        if !vm.isMember(of: forum) {
                                            if !(await vm.joinForum(forum.id)) { return }
                                        }
                                        path.append(.feed(forum: forum))
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .onAppear { vm.onAppear() }

            // DESTINOS
            .navigationDestination(for: MessageRoute.self) { route in
                switch route {
                case .feed(let forum):
                    ForumFeedScreen(forum: forum, path: $path)

                case .replies(let forumId, let rootId):
                    ForumView(forumId: forumId, rootMessageId: rootId)
                }
            }
        }
    }
}

#Preview { ForumsScreen() }
