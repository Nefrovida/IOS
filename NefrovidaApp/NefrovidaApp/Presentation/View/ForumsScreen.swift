import SwiftUI

struct ForumsScreen: View {
    @StateObject private var vm: ForumsViewModel
    @State private var path: [Int] = []
    @State private var selectedTab = 0

    init() {
        let repo: ForumRepository
        if AppConfig.useRemoteForums {
            repo = ForumRemoteRepository(baseURL: AppConfig.apiBaseURL, tokenProvider: AppConfig.tokenProvider)
        } else {
            repo = MockForumRepository()
        }
        let getForumsUC = GetForumsUseCase(repository: repo)
        let getMyForumsUC = GetMyForumsUseCase(repository: repo)
        let joinForumUC = JoinForumUseCase(repository: repo)
        _vm = StateObject(wrappedValue: ForumsViewModel(getForumsUC: getForumsUC, getMyForumsUC: getMyForumsUC, joinForumUC: joinForumUC))
    }

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                UpBar()

                Text("Tus Foros")
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
                                            path.append(forum.id)
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
                    .navigationDestination(for: Int.self) { id in
                        ForumView(forumId: id)
                    }
                }
            }
            .onAppear { vm.onAppear() }
        }
    }
}

#Preview {
    ForumsScreen()
}
