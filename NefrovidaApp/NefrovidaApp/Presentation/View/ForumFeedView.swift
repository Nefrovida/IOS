//
//  ForumFeedView.swift
//  NefrovidaApp
//
//  Created by Armando Fuentes Silva on 17/11/25.
//

import SwiftUI

struct ForumFeedView: View {
    @StateObject private var viewModel = ForumFeedViewModel()
    @State private var showNewMessageSheet = false
    @State private var showSearchView = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                VStack(spacing: 0) {
                    // Header con filtro y búsqueda
                    FeedHeader(
                        selectedFilter: $viewModel.selectedFilter,
                        onSearchTapped: {
                            showSearchView = true
                        }
                    )
                    
                    // Feed de mensajes
                    feedContent
                }
                
                // Botones flotantes
                FloatingActionButtons(
                    onNewPostTapped: {
                        showNewMessageSheet = true
                    },
                    onEditTapped: {
                        // TODO: Acción de editar/drafts
                    }
                )
                .padding(.trailing, 16)
                .padding(.bottom, 80) // Espacio para el tab bar
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // TODO: Abrir perfil
                    }) {
                        Image(systemName: "person.circle")
                            .font(.system(size: 24))
                            .foregroundColor(.primary)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Image("nefrovida-logo") // Asume que tienes el logo en assets
                        .resizable()
                        .scaledToFit()
                        .frame(height: 32)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // TODO: Abrir notificaciones
                    }) {
                        Image(systemName: "bell")
                            .font(.system(size: 24))
                            .foregroundColor(.primary)
                    }
                }
            }
            .sheet(isPresented: $showNewMessageSheet) {
                NewMessageView(onMessageSent: {
                    showNewMessageSheet = false
                    Task {
                        await viewModel.refreshFeed()
                    }
                })
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) { }
            } message: {
                if let error = viewModel.errorMessage {
                    Text(error)
                }
            }
        }
    }
    
    @ViewBuilder
    private var feedContent: some View {
        if viewModel.isLoading && viewModel.messages.isEmpty {
            LoadingFeedState()
        } else if viewModel.messages.isEmpty {
            EmptyFeedState()
        } else {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.messages) { message in
                        MessageCard(
                            message: message,
                            onMoreTapped: {
                                viewModel.showMoreOptions(for: message)
                            },
                            onLikeTapped: {
                                viewModel.toggleLike(for: message)
                            },
                            onCommentTapped: {
                                viewModel.openComments(for: message)
                            }
                        )
                        .padding(.horizontal, 12)
                        .onAppear {
                            // Infinite scroll - cargar más cuando llega al último
                            if message.id == viewModel.messages.last?.id {
                                Task {
                                    await viewModel.loadMore()
                                }
                            }
                        }
                    }
                    
                    // Indicador de carga al final
                    if viewModel.hasMore && !viewModel.messages.isEmpty {
                        ProgressView()
                            .padding()
                    }
                }
                .padding(.vertical, 12)
            }
            .refreshable {
                await viewModel.refreshFeed()
            }
        }
    }
}

#Preview {
    ForumFeedView()
}
