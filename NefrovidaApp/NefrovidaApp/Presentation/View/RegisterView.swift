//
//  RegisterView.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 01/12/25.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject private var vm: RegisterViewModel
    @Environment(\.dismiss) var dismiss
    var onSuccess: (() -> Void)?
    
    init(repository: any AuthRepository, onSuccess: (() -> Void)? = nil) {
        self.onSuccess = onSuccess
        _vm = StateObject(wrappedValue: RegisterViewModel(
            registerUseCase: RegisterUseCase(repository: repository)
        ))
    }
    
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
                ScrollView {
                    VStack {
                        NefroVidaLogo()
                            .padding(.top, 30)
                        
                        RegisterForm(
                            nombre: $vm.nombre,
                            apellidoPaterno: $vm.apellidoPaterno,
                            apellidoMaterno: $vm.apellidoMaterno,
                            telefono: $vm.telefono,
                            fechaNacimiento: $vm.fechaNacimiento,
                            genero: $vm.generoSeleccionado,
                            curp: $vm.curp,
                            username: $vm.username,
                            password: $vm.password,
                            onRegister: {
                                Task { await vm.register() }
                            },
                            onLogin: {
                                dismiss()
                            },
                            isFormValid: vm.isFormValid,
                            isLoading: vm.isLoading,
                            errorMessage: vm.errorMessage
                        )
                    }
                }
                
                .padding(20)
            }
            .onTapGesture {
                UIApplication.shared.hideKeyboard()
            }
            .onChange(of: vm.registrationCompleted) { _, newValue in
                if newValue {
                    onSuccess?()
                    dismiss()
                }
            }
        }
    }
}
