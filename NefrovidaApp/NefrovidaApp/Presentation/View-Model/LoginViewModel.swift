//
//  LoginViewModel.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 12/11/25.
//

import Foundation
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    // The username and password are received from the text inputs
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var loggedUser: LoginEntity?
    @Published var isLoggedIn: Bool = false
    
    // The logingUseCase is called
    private let loginUseCase: LoginUseCase
    
    // Initializes the login use case with a repository that handles server requests
    init() {
        let repository = AuthRepositoryD()
        self.loginUseCase = LoginUseCase(repository: repository)
    }
    
    // The fields are validated to ensure they are complete.
    func login() async {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Por favor ingresa usuario y contraseña"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Calls the login use case to perform authentication
        do {
            let user = try await loginUseCase.execute(username: username, password: password)
            self.loggedUser = user
            self.isLoggedIn = true
            print("Sesión iniciada como: \(user.username)")
        } catch {
            // If the authentication fails, an error message is sent
            self.errorMessage = handleLoginError(error)
            print("Error de login:", error.localizedDescription)
        }
        
        isLoading = false
    }
    // Depending on the server error, the message is selected.
    private func handleLoginError(_ error: Error) -> String {
        let errorDescription = error.localizedDescription.lowercased()
        if errorDescription.contains("401") || errorDescription.contains("credentials") {
            return "Usuario o contraseña incorrectos"
        } else if errorDescription.contains("network") || errorDescription.contains("connection") {
            return "Error de conexión. Verifica tu internet"
        } else if errorDescription.contains("timeout") {
            return "El servidor no responde. Intenta de nuevo"
        } else if errorDescription.contains("500") {
            return "Error del servidor. Intenta más tarde"
        } else {
            return "Error al iniciar sesión. Intenta de nuevo"
        }
    }
}
