//
//  RegisterForm.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 02/12/25.
//

import SwiftUI

struct RegisterForm: View {
    @Binding var nombre: String
    @Binding var apellidoPaterno: String
    @Binding var apellidoMaterno: String
    @Binding var telefono: String
    @Binding var fechaNacimiento: Date
    @Binding var genero: String
    @Binding var curp: String
    @Binding var username: String
    @Binding var password: String
    
    let generos = ["Masculino", "Femenino"]
    let onRegister: () -> Void
    let onLogin: () -> Void
    var isFormValid: Bool = true
    var isLoading: Bool = false
    var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 20) {
            // Título
            Text("¡Registrate ahora!")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color(red: 3/255, green: 12/255, blue: 90/255))
                .padding(.bottom, 10)
            
            // Campos del formulario
            VStack(spacing: 16) {
                textField(
                    placeholder: "Nombre *",
                    text: $nombre,
                    isSecure: false,
                    iconName: "person"
                )
                .onChange(of: nombre) { oldValue, newValue in
                    let filtered = newValue.filter { $0.isLetter || $0.isWhitespace }
                    nombre = String(filtered.prefix(60))
                }
                .padding(.horizontal, -15)
                
                textField(
                    placeholder: "Apellido Paterno *",
                    text: $apellidoPaterno,
                    isSecure: false,
                    iconName: "person"
                )
                .onChange(of: apellidoPaterno) { oldValue, newValue in
                    let filtered = newValue.filter { $0.isLetter || $0.isWhitespace }
                    apellidoPaterno = String(filtered.prefix(60))
                }
                .padding(.horizontal, -15)
                
                textField(
                    placeholder: "Apellido Materno",
                    text: $apellidoMaterno,
                    isSecure: false,
                    iconName: "person"
                )
                .onChange(of: apellidoMaterno) { oldValue, newValue in
                    let filtered = newValue.filter { $0.isLetter || $0.isWhitespace }
                    apellidoMaterno = String(filtered.prefix(60))
                }
                .padding(.horizontal, -15)
                
                textField(
                    placeholder: "Teléfono *",
                    text: $telefono,
                    isSecure: false,
                    iconName: "phone"
                )
                .onChange(of: telefono) { oldValue, newValue in
                    let filtered = newValue.filter { $0.isNumber }
                    telefono = String(filtered.prefix(15))
                }
                .padding(.horizontal, -15)
                
                nefroDate(
                    text: "Fecha de Nacimiento *",
                    placeholder: "",
                    date: $fechaNacimiento,
                    iconName: "calendar"
                )
                .padding(.horizontal, -20)
                
                nefroSelect(
                    placeholder: "Género *",
                    selection: $genero,
                    options: generos,
                    iconName: "person.2"
                )
                .padding(.horizontal, -15)
                
                textField(
                    placeholder: "CURP *",
                    text: $curp,
                    isSecure: false,
                    iconName: "doc.text"
                )
                .onChange(of: curp) { oldValue, newValue in
                    let filtered = newValue.uppercased().filter { $0.isLetter || $0.isNumber }
                    curp = String(filtered.prefix(18))
                }
                .padding(.horizontal, -15)
                
                textField(
                    placeholder: "Usuario *",
                    text: $username,
                    isSecure: false,
                    iconName: "person.circle"
                )
                .onChange(of: username) { oldValue, newValue in
                    let allowed = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_"))
                    let filtered = newValue.unicodeScalars.filter { allowed.contains($0) }
                    username = String(String.UnicodeScalarView(filtered).prefix(60))
                }
                .padding(.horizontal, -15)
                
                textField(
                    placeholder: "Contraseña *",
                    text: $password,
                    isSecure: true,
                    iconName: "eye"
                )
                .onChange(of: password) { oldValue, newValue in
                    let allowedChars = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "!@#%*+"))
                    let filtered = newValue.unicodeScalars.filter { allowedChars.contains($0) }
                    password = String(String.UnicodeScalarView(filtered).prefix(60))
                }
                .padding(.horizontal, -15)
            }
            
            // Mensaje de error
            if let error = errorMessage {
                Text(error)
                    .font(.subheadline)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top, 10)
            }
            
            // Botón de registro
            if isLoading {
                ProgressView("Registrando...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .foregroundColor(.white)
                    .padding(.top, 20)
            } else {
                nefroButton(
                    text: "Registrar",
                    color: Color(red: 3/255, green: 12/255, blue: 90/255),
                    textColor: Color(.white),
                    vertical: 15,
                    horizontal: 80,
                    textSize: 18,
                    action: onRegister
                )
                .padding(.top, 20)
                .disabled(!isFormValid)
                .opacity(isFormValid ? 1.0 : 0.6)
            }
            
            HStack(spacing: 4) {
                Button(action: onLogin) {
                    Text("¿Ya tienes cuenta? Inicia sesión")
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                }
            }
            .font(.subheadline)
            .padding(.top, 10)
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(20)
        .shadow(radius: 5)
        .frame(maxHeight: .infinity)
    }
}

// Preview
#Preview {
    @Previewable @State var nombre = ""
    @Previewable @State var apellidoPaterno = ""
    @Previewable @State var apellidoMaterno = ""
    @Previewable @State var telefono = ""
    @Previewable @State var fechaNacimiento = Date()
    @Previewable @State var genero = ""
    @Previewable @State var curp = ""
    @Previewable @State var username = ""
    @Previewable @State var password = ""
    
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
        
        ScrollView {
            RegisterForm(
                nombre: $nombre,
                apellidoPaterno: $apellidoPaterno,
                apellidoMaterno: $apellidoMaterno,
                telefono: $telefono,
                fechaNacimiento: $fechaNacimiento,
                genero: $genero,
                curp: $curp,
                username: $username,
                password: $password,
                onRegister: { print("Registrar") },
                onLogin: { print("Ir a login") },
                isFormValid: true,
                isLoading: false
            )
            .padding(20)
        }
    }
}
