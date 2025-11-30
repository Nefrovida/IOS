//
//  ForumFeedScreen.swift
//  NefrovidaApp
//

import SwiftUI

struct ForumFeedScreen: View {
    @Binding var path: [MessageRoute]
    @StateObject private var vm: FeedViewModel

    @State private var showNewMessageSheet = false
    @State private var showSuccessMessage = false

    init(forum: Forum, path: Binding<[MessageRoute]>) {
        _path = path
        _vm = StateObject(
            wrappedValue: FeedViewModel(
                repo: ForumRemoteRepository(baseURL: AppConfig.apiBaseURL),
                forumId: forum.id,
                forumName: forum.name
            )
        )
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                UpBar()

                ScrollView {
                    LazyVStack(spacing: 14) {
                        ForEach(vm.items) { item in
                            FeedCard(
                                item: item,
                                onRepliesTapped: {
                                    path.append(.replies(
                                        forumId: vm.forumId,
                                        messageId: item.id
                                    ))
                                }
                            )
                            .padding(.horizontal)
                            .onAppear {
                                // trigger de scroll infinito
                                if item.id == vm.items.last?.id {
                                    Task { await vm.loadNext() }
                                }
                            }
                        }

                        /// Loader al final
                        if vm.isLoading {
                            ProgressView()
                                .padding(.vertical, 14)
                        }
                    }
                    .padding(.vertical, 16)
                }
            }

            /// Botón flotante
            FloatingActionButtons(
                onNewPostTapped: { showNewMessageSheet = true },
                onEditTapped: {}
            )
            .padding(.trailing, 16)
            .padding(.bottom, 90)
        }
        .onReceive(NotificationCenter.default.publisher(for: .forumRepliesUpdated)) { notification in
            guard
                let userInfo = notification.userInfo,
                let messageId = userInfo["messageId"] as? Int
            else { return }

            if let index = vm.items.firstIndex(where: { $0.id == messageId }) {
                vm.items[index].replies += 1
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(vm.forumName)
        .sheet(isPresented: $showNewMessageSheet) {
            NewMessageView(
                forumId: vm.forumId,
                forumName: vm.forumName,
                onMessageSent: handleNewMessageSent
            )
        }
        .onAppear {
            /// evita doble carga
            Task {
                if vm.items.isEmpty {
                    await vm.loadNext()
                }
            }
        }
    }
}

// MARK: - Helpers
private extension ForumFeedScreen {
    func handleNewMessageSent() {
        withAnimation {
            showSuccessMessage = true
        }

        Task {
            vm.reset()
            await vm.loadNext()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                showSuccessMessage = false
            }
        }
    }
}
