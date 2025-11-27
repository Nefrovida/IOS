//
//  FeedScreen.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 23/11/25.
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
        ZStack {
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
                                if item.id == vm.items.last?.id {
                                    Task { await vm.loadNext() }
                                }
                            }
                        }
                    }
                    .padding(.vertical, 12)
                }
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    FloatingActionButtons(
                        onNewPostTapped: {
                            showNewMessageSheet = true
                        },
                        onEditTapped: {}
                    )
                    .padding(.trailing, 16)
                    .padding(.bottom, 90)
                }
            }
        }
        .navigationTitle(vm.forumName)
        .sheet(isPresented: $showNewMessageSheet) {
            NewMessageView(
                forumId: vm.forumId,
                forumName: vm.forumName,
                onMessageSent: {
                    // animación éxito
                    withAnimation {
                        showSuccessMessage = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            showSuccessMessage = false
                        }
                    }

                }
            )
        }
        .onAppear {
            Task { await vm.loadNext() }
        }
    }
}
