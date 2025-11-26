//
//  FeedScreen.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 23/11/25.
//
import SwiftUI

struct ForumFeedScreen: View {
    @StateObject private var vm: FeedViewModel
    private let forum: Forum
    
    init(forum: Forum) {
        self.forum = forum                      // <--- PRIMERO
        
        _vm = StateObject(                      // <--- DESPUÉS
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
                if vm.items.isEmpty {
                    Text("No hay contenido disponible")
                        .padding(.top, 40)
                        .foregroundColor(.secondary)
                } else {
                    LazyVStack(spacing: 14) {
                        ForEach(vm.items) { item in
                            FeedCard(item: item)
                                .padding(.horizontal)
                                .onAppear {
                                    if item.id == vm.items.last?.id {
                                        Task { await vm.loadNext() }
                                    }
                                }
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .navigationTitle(forum.name)
        .task {
            await vm.loadNext()
        }
    }
}
