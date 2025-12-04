//
//  ChangePasswordView.swift
//  NefrovidaApp
//
//  Created by Enrique Ayala on 12/01/25.
//

import SwiftUI

struct ChangePasswordView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var newPassword = ""
    @State private var confirmNewPassword = ""
    @State private var sherror = false
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 219/255, green: 230/255, blue: 237/255),
                    Color(red: 235/255, green: 245/255, blue: 250/255)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 50) {
                Spacer()
                Text("Cambiar Contraseña")
                    .font(.title)
                    .bold()
                    .padding(.top, 20)
                
                if let error = viewModel.errorMessage {
                    ErrorMessage(
                        message: error,
                        onDismiss: { sherror = true }
                    )
                }
                
                if let success = viewModel.successMessage {
                    SuccessMessage(
                        message: success,
                        onDismiss: { viewModel.successMessage = nil }
                    )
                }
                
                VStack(spacing: 25) {
                    textField(
                        placeholder: "Nueva Contraseña",
                        text: $newPassword,
                        isSecure: true,
                        iconName: "eye"
                    )
                    
                    textField(
                        placeholder: "Confirmar Nueva Contraseña",
                        text: $confirmNewPassword,
                        isSecure: true,
                        iconName: "eye"
                    )
                    if sherror {
                        Text("* La contraseña debe tener al menos 8 caracteres, una mayúscula, un número y un carácter especial [#?!@$%^&*]. *")
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .lineSpacing(5)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                nefroButton(
                    text: "Actualizar Contraseña",
                    color: Color(red: 3/255, green: 12/255, blue: 90/255),
                    textColor: .white,
                    vertical: 15,
                    horizontal: 40,
                    textSize: 18,
                    action: {
                        Task {
                            let success = await viewModel.changePassword(
                                new: newPassword,
                                confirm: confirmNewPassword
                            )
                            if success {
                                newPassword = ""
                                confirmNewPassword = ""
                                // Delay dismissal to show success message
                                try? await Task.sleep(nanoseconds: 1_500_000_000)
                                dismiss()
                            }
                        }
                    }
                )
                .padding(.bottom, 30)
            }
            
            if viewModel.isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                ProgressView()
                    .scaleEffect(1.5)
            }
        }
        .onTapGesture {
            UIApplication.shared.hideKeyboard()
        }
    }
}

#Preview {
    ChangePasswordView(viewModel: ProfileViewModel())
}
