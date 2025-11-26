//
//  ForumFeedView.swift
//  NefrovidaApp
//
//  Created by Armando Fuentes Silva on 17/11/25.
//

import SwiftUI

struct ForumFeedView: View {
    @State private var showNewMessageSheet = false
    @State private var showSearchView = false
    @State private var showSuccessMessage = false
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                UpBar()
                
                // Contenido principal - placeholder hasta que se implemente GET de mensajes
                VStack(spacing: 20) {
                    Spacer()
                    
                    Image(systemName: "bubble.left.and.bubble.right")
                        .font(.system(size: 60))
                        .foregroundColor(.gray.opacity(0.5))
                    
                    Text("Foro de Mensajes")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("Pulsa el botón + para crear un nuevo mensaje")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
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
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Spacer(minLength: 0)
                BottomBar(idUser: "user")
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
            NewMessageView(onMessageSent: {
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
            })
        }
    }
}

#Preview {
    ForumFeedView()
}
