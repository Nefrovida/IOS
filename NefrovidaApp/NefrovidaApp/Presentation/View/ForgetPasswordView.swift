//
//  ForgetPasswordView.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 03/12/25.
//

import SwiftUI

struct RecoverPasswordView: View {
    @ObservedObject var viewModel: LoginViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var userField: String = ""
    @State private var isSending = false
    @State private var message: String?
    @State private var success: Bool = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.35)
                .ignoresSafeArea()
                .onTapGesture { dismiss() }
            
            VStack(spacing: 18) {
                
                HStack {
                    Text("Recuperar Contraseña")
                        .font(.title3).bold()
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                }
                
                Text("Ingresa tu nombre de usuario y notificaremos a un administrador para que te ayude a restablecer tu contraseña.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                
                VStack(alignment: .leading) {
                    Text("Usuario").font(.caption).foregroundColor(.gray)
                    
                    TextField("Nombre de usuario", text: $userField)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .onChange(of: userField) { oldValue, newValue in
                            let allowed = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_"))
                            let filtered = newValue.unicodeScalars.filter { allowed.contains($0) }
                            userField = String(String.UnicodeScalarView(filtered).prefix(60))
                        }
                }
                
                if let message = message {
                    Text(message)
                        .foregroundColor(success ? .green : .red)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                }
                
                Button(action: sendRequest) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.nvBrand)
                            .frame(height: 48)
                        
                        if isSending {
                            ProgressView().tint(.white)
                        } else {
                            Text("Enviar Solicitud")
                                .foregroundColor(.white)
                                .bold()
                        }
                    }
                }
                .disabled(isSending || userField.isEmpty)
                .opacity(isSending || userField.isEmpty ? 0.6 : 1)
                
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(20)
            .padding(.horizontal, 24)
            .shadow(radius: 10)
        }
        .animation(.easeInOut, value: isSending)
    }
    
    private func sendRequest() {
        guard !userField.isEmpty else { return }
        
        isSending = true
        message = nil
        
        Task {
            do {
                let ok = try await viewModel.sendForgotPasswordRequest(username: userField)
                
                success = ok
                message = "Solicitud enviada. Un administrador te contactará."
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    dismiss()
                }
                
            } catch {
                success = false
                message = "No fue posible enviar la solicitud."
            }
            isSending = false
        }
    }
}
