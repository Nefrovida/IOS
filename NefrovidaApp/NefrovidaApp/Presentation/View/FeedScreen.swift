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
                repo: ForumRemoteRepository(baseURL: AppConfig.apiBaseURL),
                forumId: forumId
            )
        )
    }

    var body: some View {
        VStack(spacing: 0) { /// <-- Junta todo
            UpBar() /// <-- Siempre arriba
            ScrollView {
                if vm.items.isEmpty {
                    VStack {
                        Spacer(minLength: 80)
                        Text("No hay contenido disponible")
                            .foregroundColor(.secondary)
                    }
                }

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
                .padding(.top, 12)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            Task { await vm.loadNext() }
        }
    }
}
#Preview {
    ForumFeedScreen(forumId: 2)
}
