//
//  NewMessageView.swift
//  NefrovidaApp
//
//  Created by Armando Fuentes Silva on 17/11/25.
//

import SwiftUI
import Combine

struct NewMessageView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: NewMessageViewModel
    
    let onMessageSent: () -> Void
    
    init(forumId: Int, forumName: String, onMessageSent: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: NewMessageViewModel(forumId: forumId, forumName: forumName))
        self.onMessageSent = onMessageSent
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Selector de foro
                forumSelector
                
                Divider()
                
                messageEditor
                
                Spacer()
            }
            .onTapGesture {
                UIApplication.shared.hideKeyboard()
            }
            .navigationTitle("Nuevo Mensaje")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Publicar") {
                        Task {
                            await viewModel.sendMessage()
                            if viewModel.isSuccess {
                                dismiss()
                                onMessageSent()
                            }
                        }
                    }
                    .disabled(!viewModel.isValid || viewModel.isLoading)
                    .fontWeight(.semibold)
                }
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) { }
            } message: {
                if let error = viewModel.errorMessage {
                    Text(error)
                }
            }
            .alert("Éxito", isPresented: $viewModel.showSuccess) {
                Button("OK", role: .cancel) {
                    dismiss()
                    onMessageSent()
                }
            } message: {
                Text("Mensaje publicado correctamente")
            }
        }
    }
    
    private var forumSelector: some View {
        HStack {
            Text("Publicar en:")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(viewModel.selectedForumName)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding()
    }
    
    private var messageEditor: some View {
        VStack(alignment: .trailing, spacing: 8) {
            TextEditor(text: $viewModel.messageText)
                .frame(minHeight: 200)
                .padding(8)
                .overlay(
                    Group {
                        if viewModel.messageText.isEmpty {
                            Text("¿Qué quieres compartir?")
                                .foregroundColor(.gray)
                                .padding(.leading, 12)
                                .padding(.top, 16)
                                .allowsHitTesting(false)
                        }
                    },
                    alignment: .topLeading
                )
            
            Text("\(viewModel.messageText.count)/1000")
                .font(.caption)
                .foregroundColor(viewModel.characterCountColor)
                .padding(.trailing)
        }
        .padding(.top)
    }
}

// MARK: - ViewModel
@MainActor
class NewMessageViewModel: ObservableObject {
    @Published var messageText: String = ""
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    @Published var showSuccess: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    let selectedForumId: Int
    let selectedForumName: String
    
    private let repository = ForumRemoteRepository(
        baseURL: AppConfig.apiBaseURL,
        tokenProvider: AppConfig.tokenProvider
    )
    
    init(forumId: Int, forumName: String) {
        self.selectedForumId = forumId
        self.selectedForumName = forumName
    }
    
    var isValid: Bool {
        !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && messageText.count <= 1000
    }
    
    var characterCountColor: Color {
        if messageText.count > 1000 {
            return .red
        } else if messageText.count > 900 {
            return .orange
        } else {
            return .gray
        }
    }
    
    func sendMessage() async {
        guard isValid else { return }
        
        isLoading = true
        isSuccess = false
        errorMessage = nil
        
        #if DEBUG
        print("📤 Enviando mensaje al foro \(selectedForumId)")
        print("📝 Contenido: \(messageText.prefix(50))...")
        #endif
        
        do {
            let success = try await repository.postMessage(
                forumId: selectedForumId,
                content: messageText
            )
            #if DEBUG
            print("✅ Mensaje enviado: \(success)")
            #endif
            if success {
                isSuccess = true
                showSuccess = true
            }
        } catch {
            #if DEBUG
            print("❌ Error al enviar mensaje: \(error)")
            #endif
            setError("Error al enviar el mensaje: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    private func setError(_ message: String) {
        errorMessage = message
        showError = true
    }
}
