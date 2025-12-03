import SwiftUI

enum MessageRoute: Hashable {
    case feed(forum: Forum)
    case replies(forumId: Int, messageId: Int)
}

struct ForumsScreen: View {
    @StateObject private var vm: ForumsViewModel
    @State private var path: [MessageRoute] = []
    @State private var selectedTab = 0

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
                    VStack(spacing: 0) {
                        Picker("Filtro", selection: $selectedTab) {
                            Text("Mis Foros").tag(0)
                            Text("Todos los Foros").tag(1)
                        }
                        .pickerStyle(.segmented)
                        .padding()

                        ScrollView {
                            VStack(spacing: 12) {
                                let forumsToShow = selectedTab == 0 ? vm.myForums : vm.forums
                                
                                if forumsToShow.isEmpty {
                                    Text(selectedTab == 0 ? "No te has unido a ningún foro aún" : "No hay foros disponibles")
                                        .foregroundColor(.gray)
                                        .padding(.top, 40)
                                } else {
                                    ForEach(forumsToShow) { forum in
                                        ForumCard(forum: forum, isMember: vm.isMember(of: forum)) {
                                            Task {
                                                // If not a member, join first
                                                if !vm.isMember(of: forum) {
                                                    let success = await vm.joinForum(forum.id)
                                                    if !success {
                                                        return // Don't navigate if join failed
                                                    }
                                                }
                                                // Navigate to forum detail
                                                path.append(.feed(forum: forum))
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                            .padding(.vertical)
                        }
                        .refreshable {
                            vm.refresh()
                        }
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
