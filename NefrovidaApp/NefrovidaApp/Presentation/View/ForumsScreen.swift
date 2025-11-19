import SwiftUI

struct ForumsScreen: View {
    @StateObject private var vm: ForumsViewModel
    @State private var path: [Int] = []

    init() {
        let repo: ForumRepository
        if AppConfig.useRemoteForums {
            repo = ForumRemoteRepository(baseURL: AppConfig.apiBaseURL, tokenProvider: AppConfig.tokenProvider)
        } else {
            repo = MockForumRepository()
        }
        let getForumsUC = GetForumsUseCase(repository: repo)
        let getMyForumsUC = GetMyForumsUseCase(repository: repo)
        _vm = StateObject(wrappedValue: ForumsViewModel(getForumsUC: getForumsUC, getMyForumsUC: getMyForumsUC))
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
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(vm.forums) { forum in
                                ForumCard(forum: forum, isMember: vm.isMember(of: forum)) {
                                    // Navigate to forum detail
                                    path.append(forum.id)
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                    .navigationDestination(for: Int.self) { id in
                        ForumDetailScreen(forumId: id)
                    }
                }

                BottomBar()
            }
            .onAppear { vm.onAppear() }
        }
    }
}

#Preview {
    ForumsScreen()
}
