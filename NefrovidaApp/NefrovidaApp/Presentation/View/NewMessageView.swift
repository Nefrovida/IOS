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
    @StateObject private var viewModel = NewMessageViewModel()
    
    let onMessageSent: () -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Selector de foro
                forumSelector
                
                Divider()
                
                // Editor de mensaje
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
        }
    }
    
    private var forumSelector: some View {
        HStack {
            Text("Publicar en:")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
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
    @Published var selectedForumId: Int = 1
    @Published var selectedForumName: String = "Seleccionar foro"
    @Published var availableForums: [ForumInfo] = []
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    private let repository = ForumRepository()
    
    init() {
        // TODO: Cargar foros del usuario
        // Por ahora, datos de ejemplo
        availableForums = [
            ForumInfo(id: 1, name: "Foro de Salud"),
            ForumInfo(id: 2, name: "Consultas Médicas"),
            ForumInfo(id: 3, name: "Apoyo Familiar")
        ]
        if let first = availableForums.first {
            selectedForumId = first.id
            selectedForumName = first.name
        }
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
        
        do {
            _ = try await repository.sendMessage(
                forumId: selectedForumId,
                content: messageText
            )
            isSuccess = true
        } catch let error as NetworkError {
            setError(getNetworkErrorMessage(error))
        } catch {
            setError("Error inesperado al enviar el mensaje")
        }
        
        isLoading = false
    }
    
    private func setError(_ message: String) {
        errorMessage = message
        showError = true
    }
    
    private func getNetworkErrorMessage(_ error: NetworkError) -> String {
        switch error {
        case .invalidURL:
            return "URL inválida"
        case .invalidResponse:
            return "Respuesta inválida del servidor"
        case .unauthorized:
            return "No autorizado. Por favor inicia sesión nuevamente"
        case .serverError(let message):
            return "Error del servidor: \(message)"
        case .decodingError:
            return "Error al procesar la respuesta"
        case .unknown:
            return "Error desconocido"
        }
    }
}

// MARK: - Helper Model
struct ForumInfo: Identifiable {
    let id: Int
    let name: String
}

#Preview {
    NewMessageView(onMessageSent: {})
}
