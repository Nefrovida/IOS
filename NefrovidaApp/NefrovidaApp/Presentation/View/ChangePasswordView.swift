//
//  ChangePasswordView.swift
//  NefrovidaApp
//
//  Created by Enrique Ayala on 12/01/25.
//

import SwiftUI

struct ChangePasswordView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmNewPassword = ""
    
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
            
            VStack(spacing: 20) {
                Text("Cambiar Contraseña")
                    .font(.title)
                    .bold()
                    .padding(.top, 20)
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                if let success = viewModel.successMessage {
                    Text(success)
                        .foregroundColor(.green)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                VStack(spacing: 15) {
                    textField(
                        placeholder: "Contraseña Actual",
                        text: $currentPassword,
                        isSecure: true,
                        iconName: "eye"
                    )
                    
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
                                current: currentPassword,
                                new: newPassword,
                                confirm: confirmNewPassword
                            )
                            if success {
                                // Clear fields or dismiss?
                                // For now, just clear fields
                                currentPassword = ""
                                newPassword = ""
                                confirmNewPassword = ""
                                // Delay dismissal to show success message
                                try? await Task.sleep(nanoseconds: 1_500_000_000)
                                presentationMode.wrappedValue.dismiss()
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
