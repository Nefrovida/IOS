//
//  loginView.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 11/11/25.
//

import SwiftUI

struct loginView: View {
    @Binding var isLoggedIn: Bool
    @Binding var loggedUser: LoginEntity?
    @Binding var isFirstLogin: Bool
    
    @StateObject private var viewModel = LoginViewModel()
    @State private var goToRegister = false
    @State private var accountCreated = false
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 219/255, green: 230/255, blue: 237/255),
                        Color(red: 3/255, green: 12/255, blue: 90/255)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack {
                    
                    NefroVidaLogo()
                        .padding(.top, 30)
                    
                    if let error = viewModel.errorMessage {
                        ErrorMessage(
                            message: error,
                            onDismiss: { viewModel.errorMessage = nil }
                        )
                    }
                    
                    if accountCreated {
                        SuccessMessage(
                            message: "¡Cuenta creada con éxito!",
                            onDismiss: { accountCreated = false }
                        )
                    }
                    
                    LoginForm(
                        user: $viewModel.username,
                        password: $viewModel.password,
                        onLogin: { Task { await viewModel.login() }},
                        onCreateAccount: { goToRegister = true },
                        onForgotPassword: { viewModel.forgotPassword = true }
                    )
                    .frame(maxHeight: .infinity)
                    
                    if viewModel.isLoading {
                        ProgressView("Iniciando sesión...")
                            .padding(.top, 20)
                    }
                }
                .padding(20)
            }
            .onTapGesture {
                UIApplication.shared.hideKeyboard()
            }
            
            .navigationDestination(isPresented: $goToRegister) {
                RegisterView(
                    repository: AuthRepositoryD(),
                    onSuccess: { accountCreated = true }
                )
                .navigationTitle("Registrar Usuario")
            }
            
            .onChange(of: viewModel.loggedUser) {
                if let user = viewModel.loggedUser {
                    if user.role_id == 3 {
                        loggedUser = user
                        isLoggedIn = true
                    } else {
                        viewModel.errorMessage = "Esta aplicación es solo para pacientes. Por favor contacta al administrador."
                        viewModel.loggedUser = nil
                    }
                }
            }
            
            .fullScreenCover(isPresented: $isLoggedIn) {
                HomeView()
            }
        }
        .onChange(of: viewModel.isFirstLogin) { _, newValue in
            isFirstLogin = newValue
        }

        .fullScreenCover(isPresented: $viewModel.forgotPassword) {
            RecoverPasswordView(viewModel: viewModel)
        }
    }
}
