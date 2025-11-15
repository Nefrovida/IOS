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
    // Call the login logic from the viewModel
    var onLogin: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("¡Bienvenid@!")
                .font(Font.largeTitle.bold())
                .foregroundColor(Color(red: 3/255, green: 12/255, blue: 90/255))
                .padding(20)
            // The textField atom is used for the User and Password field
            textField(placeholder: "Usuario", text: $user, isSecure: false, iconName: "xmark")
            textField(placeholder: "Contraseña", text: $password, isSecure: true, iconName: "eye")
            
            // Button that redirects to the view for change the password
            Button("¿Olvidaste tu contraseña?") {}
            .font(.caption)
            .foregroundColor(.blue)
            .padding()
            
            // The nefroButton is used for the Log In button
            nefroButton(
                text: "Iniciar Sesión",
                color: Color(red: 3/255, green: 12/255, blue: 90/255),
                textColor: .white,
                vertical: 10,
                horizontal: 50,
                // Variable that adds the cyan stroke around the button
                hasStroke: false,
                textSize: 18,
                action: onLogin
            )
            // Button that redirects to the view for creating a new account
            Button("¿Nuevo? Crea tu cuenta aquí") {}
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

// A preview to visualize the aplication of the loginForm
#Preview {
    @Previewable @State var password = ""
    @Previewable @State var user = ""
    LoginForm(user: $user, password: $password, onLogin: { })
}
