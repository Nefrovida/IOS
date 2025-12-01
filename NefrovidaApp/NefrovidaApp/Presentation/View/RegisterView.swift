//
//  RegisterView.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 01/12/25.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject private var vm: RegisterViewModel
    @State private var showPassword = false
    @Environment(\.dismiss) var dismiss
    var onSuccess: (() -> Void)?
    
    let generos = ["Masculino", "Femenino", "Otro"]
    
    init(repository: any AuthRepository, onSuccess: (() -> Void)? = nil) {
        self.onSuccess = onSuccess
        _vm = StateObject(wrappedValue: RegisterViewModel(
            registerUseCase: RegisterUseCase(repository: repository)
        ))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    VStack(spacing: 8) {
                        Text("NEFROVida")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.blue)
                        
                        Text("Asociación Civil")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text("¡Bienvenid@!")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.top, 20)
                        
                        HStack(spacing: 12) {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 40, height: 40)
                                .overlay(Text("1").foregroundColor(.white).fontWeight(.semibold))
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 40, height: 2)
                            
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 40, height: 40)
                                .overlay(Text("2").foregroundColor(.gray).fontWeight(.semibold))
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 40, height: 2)
                            
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 40, height: 40)
                                .overlay(Text("3").foregroundColor(.gray).fontWeight(.semibold))
                        }
                        .padding(.top, 10)
                    }
                    .padding(.top, 40)
                    
                    VStack(spacing: 16) {
                        
                        textField(
                            placeholder: "Nombre *",
                            text: $vm.nombre,
                            iconName: "person"
                        )
                        
                        textField(
                            placeholder: "Apellido Paterno *",
                            text: $vm.apellidoPaterno,
                            iconName: "person"
                        )
                        
                        textField(
                            placeholder: "Apellido Materno",
                            text: $vm.apellidoMaterno,
                            iconName: "person"
                        )
                        
                        textField(
                            placeholder: "Teléfono *",
                            text: $vm.telefono,
                            iconName: "phone"
                        )
                        .keyboardType(.phonePad)

                        HStack(spacing: 16) {
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Fecha de Nacimiento *")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding(.leading, 4)
                                
                                DatePicker(
                                    "",
                                    selection: $vm.fechaNacimiento,
                                    displayedComponents: .date
                                )
                                .datePickerStyle(.compact)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                            }
                            
                            SelectField(
                                label: "Género *",
                                options: generos,
                                selection: Binding(
                                    get: { vm.generoSeleccionado },
                                    set: { vm.generoSeleccionado = $0 ?? "" }
                                )
                            )
                        }
                        .padding(.horizontal)
                        
                        textField(
                            placeholder: "CURP *",
                            text: $vm.curp,
                            iconName: "doc.text"
                        )
                        .textInputAutocapitalization(.characters)
                        
                        textField(
                            placeholder: "Usuario *",
                            text: $vm.username,
                            iconName: "person.circle"
                        )
                        .textInputAutocapitalization(.never)
                        
                        textField(
                            placeholder: "Contraseña *",
                            text: $vm.password,
                            isSecure: true,
                            iconName: "eye"
                        )
                    }
                    .padding(.top, 20)
                    
                    if let error = vm.errorMessage {
                        Text(error)
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .padding(.top, 10)
                    }
                    
                    Button {
                        Task { await vm.register() }
                    } label: {
                        if vm.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            Text("Siguiente")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                        }
                    }
                    .background(vm.isFormValid ? Color.blue : Color.gray)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .disabled(!vm.isFormValid || vm.isLoading)
                    .onChange(of: vm.registrationCompleted) { _, newValue in
                        if newValue {
                            onSuccess?()
                            dismiss()
                        }
                    }
                    HStack {
                        Text("¿Ya tienes cuenta?")
                            .foregroundColor(.gray)
                        
                        Button("Inicia sesión") {
                            // TODO: Navegar a LoginView
                        }
                        .foregroundColor(.blue)
                    }
                    .font(.subheadline)
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                }
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
}
