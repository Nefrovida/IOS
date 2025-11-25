//
//  FeedScreen.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 23/11/25.
//
import SwiftUI

struct ForumFeedScreen: View {
    @StateObject private var vm: FeedViewModel

    init(forumId: Int? = nil) {
        _vm = StateObject(
            wrappedValue: FeedViewModel(
                repo: ForumRemoteRepository(
                    baseURL: AppConfig.apiBaseURL,
                ),
                forumId: forumId
            )
        )
    }

    var body: some View {
        UpBar()
        ScrollView {
            Spacer()
            if vm.items.isEmpty {
                Text("No hay contenido disponible")
            }
            LazyVStack(spacing: 14) {
                ForEach(vm.items) { item in
                    FeedCard(item: item)
                        .padding(.horizontal)
                        .onAppear {
                            /// Infinite scroll
                            if item.id == vm.items.last?.id {
                                Task { await vm.loadNext() }
                            }
                        }
                }
            }
            .padding(.vertical)
        }
        .onAppear {
            Task { await vm.loadNext() }
        }
    }
}

#Preview {
    ForumFeedScreen(forumId: 2)
}
