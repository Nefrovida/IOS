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
        .sheet(isPresented: $showNewMessageSheet) {
            NewMessageView(
                forumId: vm.forumId,
                forumName: vm.forumName,
                onMessageSent: {
                    Task {
                        vm.items.removeAll()
                        await vm.loadNext()
                    }
                }
            )
        }
        .navigationTitle(vm.forumName)
        .onAppear {
            Task { await vm.loadNext() }
        }
    }
}
