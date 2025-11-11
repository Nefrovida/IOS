//
//  textField.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 10/11/25.
//

import SwiftUI

struct textField: View {
    var placeholder: String
    @Binding var text: String
    // Flag used to determine if the text should be protected or not.
    var isSecure: Bool = false
    var iconName: String?
    
    // Flag used to determine whether text is visible or not.
    @State private var showText: Bool = false

    var body: some View {
        HStack {
            if isSecure && !showText {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
                    .autocapitalization(.none)
                    .keyboardType(.default)
            }
            // Depending of the icon it has a special funcionality.
            // If is "eye", you can either see or hide the text in the text field.
            if iconName == "eye" {
                Button(action: {
                    showText.toggle()
                }) {
                    Image(systemName: showText ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            // If is "xmark", you can delete whatever is in the text field.
            } else if iconName == "xmark" {
                if !text.isEmpty {
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            // Any other icon is simply displayed in the text field.
            } else if let icon = iconName {
                Image(systemName: icon)
                    .foregroundColor(.gray)
            }
        }
        // Here, the style of the textField is defined
        .padding()
        .background(Color.white)
        .cornerRadius(30)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.cyan.opacity(0.7), lineWidth: 2))
                .shadow(color: Color.cyan.opacity(0.3), radius: 6, x: 0, y: 3)
                .padding(.horizontal)
                .shadow(radius: 2)
    }
}

// A preview to visualize the aplication of the textField
#Preview {
    @Previewable @State var password = ""
    @Previewable @State var email = ""
    VStack(spacing: 20) {
        textField(
            placeholder: "Correo electrónico",
            text: $email,
            isSecure: false,
            iconName: "xmark"
        )
        textField(
            placeholder: "Contraseña",
            text: $password,
            isSecure: true,
            iconName: "eye"
        )
    }

}
