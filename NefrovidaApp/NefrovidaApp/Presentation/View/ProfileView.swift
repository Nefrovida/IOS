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
    @State private var parentLastName: String = ""
    @State private var maternalLastName: String = ""
    @State private var phoneNumber: String = ""
    @State private var gender: String = ""
    @State private var birthday: Date = Date()
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
                            
                            if let email = profile.email {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Email")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .padding(.leading)
                                    
                                    Text(email)
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
                            }
                            
                            // Editable fields
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Nombre")
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
                                Text("Apellido Paterno")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.leading)
                                
                                textField(
                                    placeholder: "Apellido Paterno",
                                    text: $parentLastName,
                                    isSecure: false,
                                    iconName: "person"
                                )
                            }
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Apellido Materno")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.leading)
                                
                                textField(
                                    placeholder: "Apellido Materno (Opcional)",
                                    text: $maternalLastName,
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
                                .keyboardType(.numberPad)
                            }
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Género")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.leading)
                                
                                Picker("Género", selection: $gender) {
                                    Text("Seleccionar").tag("")
                                    Text("Masculino").tag("MALE")
                                    Text("Femenino").tag("FEMALE")
                                    Text("Otro").tag("OTHER")
                                }
                                .pickerStyle(.menu)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .cornerRadius(22)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 22)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .padding(.horizontal)
                            }
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Fecha de Nacimiento")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.leading)
                                
                                DatePicker(
                                    "",
                                    selection: $birthday,
                                    in: ...Date(),
                                    displayedComponents: .date
                                )
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .cornerRadius(22)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 22)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .padding(.horizontal)
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
                                            let birthdayString = ISO8601DateFormatter().string(from: birthday).prefix(10)
                                            await viewModel.updateProfile(
                                                name: name,
                                                parentLastName: parentLastName,
                                                maternalLastName: maternalLastName.isEmpty ? nil : maternalLastName,
                                                phoneNumber: phoneNumber,
                                                gender: gender.isEmpty ? nil : gender,
                                                birthday: String(birthdayString)
                                            )
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
                self.parentLastName = profile.parentLastName
                self.maternalLastName = profile.maternalLastName ?? ""
                self.phoneNumber = profile.phoneNumber ?? ""
                self.gender = profile.gender ?? ""
                
                // Parse birthday string to Date
                if let birthdayString = profile.birthday,
                   let date = ISO8601DateFormatter().date(from: birthdayString) {
                    self.birthday = date
                } else if let birthdayString = profile.birthday {
                    // Try simple date format YYYY-MM-DD
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    if let date = formatter.date(from: birthdayString) {
                        self.birthday = date
                    }
                }
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
