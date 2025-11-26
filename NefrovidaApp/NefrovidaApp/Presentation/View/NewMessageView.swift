//
//  NewMessageView.swift
//  NefrovidaApp
//
//  Created by Armando Fuentes Silva on 17/11/25.
//

import SwiftUI
import Combine

struct NewMessageView: View {
    let forumId : Int
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = NewMessageViewModel()
    
    let onMessageSent: () -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Selector de foro
                forumSelector
                
                Divider()
                
                messageEditor
                
                Spacer()
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
            .onAppear {
                Task {
                    await viewModel.loadForums()
                }
            }
        }
    }
    
    private var forumSelector: some View {
        HStack {
            Text("Publicar en:")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if viewModel.isLoadingForums {
                ProgressView()
                    .scaleEffect(0.8)
                Text("Cargando foros...")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else if viewModel.availableForums.isEmpty {
                VStack(alignment: .leading) {
                    Text("No hay foros disponibles")
                        .font(.subheadline)
                        .foregroundColor(.red)
                    if let debugInfo = viewModel.debugInfo {
                        Text(debugInfo)
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
            } else {
                Menu {
                    ForEach(viewModel.availableForums, id: \.id) { forum in
                        Button(forum.name) {
                            viewModel.selectedForumId = forum.id
                            viewModel.selectedForumName = forum.name
                        }
                    }
                } label: {
                    HStack {
                        Text(viewModel.selectedForumName)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Image(systemName: "chevron.down")
                            .font(.caption)
                    }
                    .foregroundColor(.blue)
                }
            }
            
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
    @Published var selectedForumId: Int = 0
    @Published var selectedForumName: String = "Seleccionar foro"
    @Published var availableForums: [Forum] = []
    @Published var isLoading: Bool = false
    @Published var isLoadingForums: Bool = false
    @Published var isSuccess: Bool = false
    @Published var showSuccess: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    @Published var debugInfo: String?
    
    private let repository = ForumRemoteRepository(
        baseURL: AppConfig.apiBaseURL,
        tokenProvider: AppConfig.tokenProvider
    )
    
    var isValid: Bool {
        !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && messageText.count <= 1000
        && selectedForumId > 0
        && !availableForums.isEmpty
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
    
    func loadForums() async {
        isLoadingForums = true
        debugInfo = nil
        
        // Debug: verificar token
        let token = AppConfig.tokenProvider()
        print("🔐 Token disponible: \(token != nil ? "Sí (\(token!.prefix(20))...)" : "No")")
        print("🌐 Base URL: \(AppConfig.apiBaseURL)")
        
        do {
            // Usar fetchForums() para obtener todos los foros disponibles
            let forums = try await repository.fetchForums(page: nil, limit: nil, search: nil, isPublic: nil)
            print("✅ Foros recibidos: \(forums.count)")
            for forum in forums {
                print("   - ID: \(forum.id), Nombre: \(forum.name)")
            }
            
            availableForums = forums
            
            // Seleccionar el primer foro por defecto
            if let first = forums.first {
                selectedForumId = first.id
                selectedForumName = first.name
            } else {
                debugInfo = "El servidor devolvió una lista vacía"
            }
        } catch {
            print("❌ Error al cargar foros: \(error)")
            debugInfo = "Error: \(error.localizedDescription)"
            setError("Error al cargar foros: \(error.localizedDescription)")
        }
        
        isLoadingForums = false
    }
    
    func sendMessage() async {
        guard isValid else { return }
        
        isLoading = true
        isSuccess = false
        errorMessage = nil
        
        print("📤 Enviando mensaje al foro \(selectedForumId)")
        print("📝 Contenido: \(messageText.prefix(50))...")
        
        do {
            let success = try await repository.postMessage(
                forumId: selectedForumId,
                content: messageText
            )
            print("✅ Mensaje enviado: \(success)")
            if success {
                isSuccess = true
                showSuccess = true
            }
        } catch {
            print("❌ Error al enviar mensaje: \(error)")
            setError("Error al enviar el mensaje: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    private func setError(_ message: String) {
        errorMessage = message
        showError = true
    }
}

#Preview {
    NewMessageView(forumId: 1,onMessageSent: {})
}
