//
//  RegisterViewModel.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 01/12/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class RegisterViewModel: ObservableObject {
    
    @Published var nombre = ""
    @Published var apellidoPaterno = ""
    @Published var apellidoMaterno = ""
    @Published var telefono = ""
    @Published var fechaNacimiento = Date()
    @Published var generoSeleccionado = ""
    @Published var curp = ""
    @Published var username = ""
    @Published var password = ""
    
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var registrationCompleted = false
    
    private let registerUseCase: RegisterUseCase
    
    init(registerUseCase: RegisterUseCase) {
        self.registerUseCase = registerUseCase
    }
    
    var isFormValid: Bool {
        !nombre.isEmpty &&
        !apellidoPaterno.isEmpty &&
        !telefono.isEmpty &&
        !curp.isEmpty &&
        !username.isEmpty &&
        !password.isEmpty &&
        generoSeleccionado != ""
    }
    
    func register() async {
        errorMessage = nil
        
        guard validateFields() else { return }
        
        isLoading = true
        
        let genderAPI: String
        switch generoSeleccionado {
        case "Masculino":
            genderAPI = "MALE"
        case "Femenino":
            genderAPI = "FEMALE"
        default:
            genderAPI = "OTHER"
        }
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        let birthdayString = formatter.string(from: fechaNacimiento)
        
        let request = RegisterRequest(
            name: nombre,
            parentLastName: apellidoPaterno,
            maternalLastName: apellidoMaterno.isEmpty ? nil : apellidoMaterno,
            phoneNumber: telefono,
            username: username,
            password: password,
            birthday: birthdayString,
            gender: genderAPI,
            roleId: 3,
            curp: curp.uppercased()
        )
        
        do {
            _ = try await registerUseCase.execute(request: request)
            self.registrationCompleted = true
            
        } catch {
            errorMessage = handleRegisterError(error)
        }
        
        isLoading = false
    }
    
    private func validateFields() -> Bool {
        if nombre.trimmingCharacters(in: .whitespaces).isEmpty {
            errorMessage = "El nombre es requerido"
            return false
        }
        
        if apellidoPaterno.trimmingCharacters(in: .whitespaces).isEmpty {
            errorMessage = "El apellido paterno es requerido"
            return false
        }
        
        let phoneRegex = "^[0-9]{10}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        if !phonePredicate.evaluate(with: telefono) {
            errorMessage = "El teléfono debe tener 10 dígitos"
            return false
        }
        
        let curpRegex = "^[A-Z]{4}[0-9]{6}[HM][A-Z]{5}[0-9A-Z][0-9]$"
        let curpPredicate = NSPredicate(format: "SELF MATCHES %@", curpRegex)
        if !curpPredicate.evaluate(with: curp.uppercased()) {
            errorMessage = "El CURP no es válido"
            return false
        }
        
        if username.count < 3 {
            errorMessage = "El usuario debe tener al menos 3 caracteres"
            return false
        }
        
        if password.count < 5 {
            errorMessage = "La contraseña debe tener al menos 5 caracteres"
            return false
        }
        
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: fechaNacimiento, to: Date())
        if let age = ageComponents.year, age < 10 {
            errorMessage = "Debes tener al menos 10 años para registrarte"
            return false
        }
        
        return true
    }
    
    private func handleRegisterError(_ error: Error) -> String {
        let description = error.localizedDescription.lowercased()

        if description.contains("network") || description.contains("connection") {
            return "Error de conexión. Verifica tu internet."
        } else if description.contains("timeout") {
            return "El servidor tardó demasiado en responder."
        } else if description.contains("500") {
            return "Error del servidor. Intenta nuevamente más tarde."
        } else if description.contains("already") || description.contains("exists") {
            return "El usuario o CURP ya se encuentra registrado."
        } else {
            return "Ocurrió un error inesperado durante el registro."
        }
    }
}
