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
    // Connects to loginViewModel
    @StateObject private var viewModel = LoginViewModel()
    var body: some View {
        ZStack {
            // The background gradient colors is defined
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 219/255, green: 230/255, blue: 237/255),
                    Color(red: 3/255, green: 12/255, blue: 90/255)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack() {
                // It's called the nefrovida logo
                NefroVidaLogo()
                    .padding(.top, 30)
                // Error messages are displayed.
                if let error = viewModel.errorMessage {
                    ErrorMessage(
                        message: error,
                        onDismiss: {
                            viewModel.errorMessage = nil
                        })
                }
                // The loginForm molecule is used
                LoginForm(
                    user: $viewModel.username,
                    password: $viewModel.password,
                    onLogin: {Task { await viewModel.login() }}
                )
                .frame(maxHeight: .infinity)
                
                // States are defined depending on the login process.
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
        // Change to logged-in status
        .onChange(of: viewModel.loggedUser) { oldValue, newValue in
            if let user = newValue {
                loggedUser = user
                isLoggedIn = true
            }
        }

        .onChange(of: viewModel.isFirstLogin) { _, newValue in
            isFirstLogin = newValue
        }
        // Redirect to another view after logging in
        .fullScreenCover(isPresented: $isLoggedIn) {
            HomeView(user: viewModel.loggedUser)
        }
    }
}

// A preview to visualize the view of the loginView

