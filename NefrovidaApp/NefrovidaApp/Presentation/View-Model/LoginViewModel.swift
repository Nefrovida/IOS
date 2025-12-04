import Foundation
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var loggedUser: LoginEntity?
    @Published var isLoggedIn: Bool = false
    @Published var isFirstLogin: Bool = false
    
    @Published var forgotPassword: Bool = false   // para mostrar el modal
    
    private let loginUseCase: LoginUseCase
    private let isFirstLoginUseCase: isLogginUsesCase
    let forgetPasswordUseCase: ForgetPasswordUseCase

    init() {
        let authRepository = AuthRepositoryD()
        let userRepository = UserRemoteRepository()
        
        self.loginUseCase = LoginUseCase(repository: authRepository)
        self.isFirstLoginUseCase = isLogginUsesCase(repository: userRepository)
        self.forgetPasswordUseCase = ForgetPasswordUseCase(repository: ForgetPasswordRemoteRepository())
    }
    
    // LOGIN
    func login() async {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Por favor ingresa usuario y contraseña"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await loginUseCase.execute(username: username, password: password)
            let firstL = try await isFirstLoginUseCase.execute(userId: user.user_id)
            self.loggedUser = user
            self.isLoggedIn = true
            self.isFirstLogin = firstL
        } catch {
            self.errorMessage = handleLoginError(error)
        }
        
        isLoading = false
    }
    
    // FORGET PASSWORD → llama al use case
    func sendForgotPasswordRequest(username: String) async throws -> Bool {
        try await forgetPasswordUseCase.execute(userId: username, userName: username)
    }
    
    // ERRORES LOGIN
    private func handleLoginError(_ error: Error) -> String {
        let e = error.localizedDescription.lowercased()
        
        if e.contains("401") || e.contains("credentials") {
            return "Usuario o contraseña incorrectos"
        } else if e.contains("network") || e.contains("connection") {
            return "Error de conexión. Verifica tu internet"
        } else if e.contains("timeout") {
            return "El servidor no responde. Intenta de nuevo"
        } else if e.contains("500") {
            return "Error del servidor. Intenta más tarde"
        } else {
            return "Error al iniciar sesión. Intenta de nuevo"
        }
    }
}
