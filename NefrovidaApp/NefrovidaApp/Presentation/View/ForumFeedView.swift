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
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                // UpBar personalizado en lugar de NavigationBar
                UpBar()
                
                // Header con filtro y búsqueda
                FeedHeader(
                    selectedFilter: $viewModel.selectedFilter,
                    onSearchTapped: {
                        showSearchView = true
                    }
                )
                
                // Feed de mensajes
                feedContent
                
                Spacer(minLength: 0)
                
                // BottomBar personalizado
                BottomBar()
            }
            
            // Botones flotantes
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    FloatingActionButtons(
                        onNewPostTapped: {
                            showNewMessageSheet = true
                        },
                        onEditTapped: {
                            // TODO: Acción de editar/drafts
                        }
                    )
                    .padding(.trailing, 16)
                    .padding(.bottom, 90) // Espacio para el BottomBar (ajusta según necesites)
                }
            }
        }
        .edgesIgnoringSafeArea(.top) // Para que UpBar llegue hasta arriba
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
