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
    
    private let forumId: Int
    private let forumName: String
    
    init(forumId: Int, forumName: String) {
        self.forumId = forumId
        self.forumName = forumName
        _vm = StateObject(
            wrappedValue: FeedViewModel(
                repo: ForumRemoteRepository(baseURL: AppConfig.apiBaseURL),
                forumId: forumId
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
        }
        .edgesIgnoringSafeArea(.top)
        .sheet(isPresented: $showNewMessageSheet) {
            NewMessageView(
                forumId: forumId,
                forumName: forumName,
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

#Preview {
    ForumFeedScreen(forumId: 2, forumName: "Foro Salud 2")
}
