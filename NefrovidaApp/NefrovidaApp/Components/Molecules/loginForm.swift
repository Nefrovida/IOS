//
//  loginForm.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 11/11/25.
//

import SwiftUI

struct LoginForm: View {
    @Binding var user: String
    @Binding var password: String
    
    var onLogin: () -> Void
    var onCreateAccount: () -> Void
    var onForgotPassword: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("¡Bienvenid@!")
                .font(Font.largeTitle.bold())
                .foregroundColor(Color(red: 3/255, green: 12/255, blue: 90/255))
                .padding(20)

            textField(placeholder: "Usuario", text: $user, isSecure: false, iconName: "xmark")
                .onChange(of: user) { oldValue, newValue in
                    let allowed = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_"))
                    let filtered = newValue.unicodeScalars.filter { allowed.contains($0) }
                    user = String(String.UnicodeScalarView(filtered).prefix(60))
                }

            textField(placeholder: "Contraseña", text: $password, isSecure: true, iconName: "eye")
                .onChange(of: password) { oldValue, newValue in
                    let allowedChars = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "!@#%*+"))
                    let filtered = newValue.unicodeScalars.filter { allowedChars.contains($0) }
                    password = String(String.UnicodeScalarView(filtered).prefix(60))
                }
            
            Button("¿Olvidaste tu contraseña?") {
                onForgotPassword()
            }
            .font(.caption)
            .foregroundColor(.blue)
            .padding()
            
            nefroButton(
                text: "Iniciar Sesión",
                color: Color(red: 3/255, green: 12/255, blue: 90/255),
                textColor: .white,
                vertical: 10,
                horizontal: 50,
                hasStroke: false,
                textSize: 18,
                action: onLogin
            )

            Button("¿Nuevo? Crea tu cuenta aquí") { onCreateAccount() }
                .font(.footnote)
                .foregroundColor(.gray)
                .padding()
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}
