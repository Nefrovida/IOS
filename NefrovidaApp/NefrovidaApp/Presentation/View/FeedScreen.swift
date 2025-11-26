//
//  FeedScreen.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 23/11/25.
//
import SwiftUI

struct ForumFeedScreen: View {
    @StateObject private var vm: FeedViewModel
    @State private var showNewMessageSheet = false
    @State private var showSuccessMessage = false
    @State private var navPath: [MessageRoute] = []
    
    enum MessageRoute: Hashable {
        case replies(forumId: Int, messageId: Int)
    }
    
    init(forum: Forum) {
        _vm = StateObject(
            wrappedValue: FeedViewModel(
                repo: ForumRemoteRepository(baseURL: AppConfig.apiBaseURL),
                forumId: forum.id,
                forumName: forum.name
            )
        )
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                UpBar()
                
                ScrollView {
                    if vm.items.isEmpty {
                        VStack {
                            Spacer(minLength: 80)
                            Text("No hay contenido disponible")
                                .foregroundColor(.secondary)
                            
                            if showSuccessMessage {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text("¡Mensaje enviado correctamente!")
                                        .foregroundColor(.green)
                                }
                                .padding()
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(10)
                                .transition(.opacity.combined(with: .scale))
                                .padding(.top, 20)
                            }
                        }
                        .padding(.top, 40)
                    }
                    
                    LazyVStack(spacing: 14) {
                        ForEach(vm.items) { item in
                            FeedCard(item: item,
                                     onRepliesTapped: {
                                navPath.append(.replies(
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
                    .padding(.bottom, 90)
                    
                }
            }
            .navigationTitle(vm.forumName)
            
            .edgesIgnoringSafeArea(.top)
            .sheet(isPresented: $showNewMessageSheet) {
                NewMessageView(
                    forumId: vm.forumId,
                    forumName: vm.forumName,
                    onMessageSent: {
                        // Mostrar mensaje de éxito temporalmente
                        withAnimation {
                            showSuccessMessage = true
                        }
                        // Ocultar después de 3 segundos
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                showSuccessMessage = false
                            }
                        }
                        // Recargar el feed después de enviar el mensaje
                        Task {
                            vm.items.removeAll()
                            await vm.loadNext()
                        }
                    })
            }
            .onAppear {
                Task { await vm.loadNext() }
            }
        }
    }
}
