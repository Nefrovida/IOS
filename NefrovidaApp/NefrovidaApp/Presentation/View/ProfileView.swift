//
//  ProfileView.swift
//  NefrovidaApp
//
//  Created by Enrique Ayala on 12/01/25.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var name: String = ""
    @State private var phoneNumber: String = ""
    @State private var showChangePassword = false
    
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
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Mi Perfil")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Color(red: 3/255, green: 12/255, blue: 90/255))
                    Spacer()
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 20) {
                        if let profile = viewModel.profile {
                            // Read-only fields
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Usuario")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.leading)
                                
                                Text(profile.username)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white.opacity(0.5))
                                    .cornerRadius(22)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 22)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                                    .padding(.horizontal)
                            }
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Email")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.leading)
                                
                                Text(profile.email ?? "No registrado")
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white.opacity(0.5))
                                    .cornerRadius(22)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 22)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                                    .padding(.horizontal)
                            }
                            
                            // Editable fields
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Nombre Completo")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.leading)
                                
                                textField(
                                    placeholder: "Nombre",
                                    text: $name,
                                    isSecure: false,
                                    iconName: "person"
                                )
                            }
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Teléfono")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.leading)
                                
                                textField(
                                    placeholder: "Teléfono",
                                    text: $phoneNumber,
                                    isSecure: false,
                                    iconName: "phone"
                                )
                            }
                            
                            // Messages
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
                            
                            // Actions
                            VStack(spacing: 15) {
                                nefroButton(
                                    text: "Guardar Cambios",
                                    color: Color(red: 3/255, green: 12/255, blue: 90/255),
                                    textColor: .white,
                                    vertical: 15,
                                    horizontal: 40,
                                    textSize: 18,
                                    action: {
                                        Task {
                                            await viewModel.updateProfile(name: name, phoneNumber: phoneNumber)
                                        }
                                    }
                                )
                                
                                Button(action: {
                                    showChangePassword = true
                                }) {
                                    Text("Cambiar Contraseña")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(Color(red: 3/255, green: 12/255, blue: 90/255))
                                        .underline()
                                }
                                .padding(.top, 10)
                            }
                            .padding(.top, 20)
                            
                        } else {
                            // Loading state or empty
                            if !viewModel.isLoading {
                                Text("No se pudo cargar el perfil")
                                    .foregroundColor(.gray)
                                    .padding()
                                Button("Reintentar") {
                                    Task { await viewModel.loadProfile() }
                                }
                            }
                        }
                    }
                    .padding(.bottom, 50)
                }
            }
            
            if viewModel.isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                ProgressView()
                    .scaleEffect(1.5)
            }
        }
        .onAppear {
            Task {
                await viewModel.loadProfile()
            }
        }
        .onChange(of: viewModel.profile) { oldValue, newValue in
            if let profile = newValue {
                self.name = profile.name
                self.phoneNumber = profile.phoneNumber ?? ""
            }
        }
        .sheet(isPresented: $showChangePassword) {
            ChangePasswordView(viewModel: viewModel)
        }
        .onTapGesture {
            UIApplication.shared.hideKeyboard()
        }
    }
}

#Preview {
    ProfileView()
}
