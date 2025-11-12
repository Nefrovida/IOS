//
//  CreateDoctorView.swift
//  NefrovidaApp
//
//  Created by Ana Paola Hernandez  on 11/11/25.
//


import SwiftUI

struct CreateDoctorView: View {
    @ObservedObject var viewModel: CreateDoctorViewModel

    var body: some View {
        VStack(spacing: 16) {
            Text("Crear cuenta de doctor")
                .font(.title2)
                .bold()
                .padding(.bottom, 20)
            
            Text("Nombre del doctor:")
                .font(.title3)
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("Nombre", text: $viewModel.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.words)

            Text("Especialidad:")
                .font(.title3)
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("Especialidad", text: $viewModel.specialty)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Text("Cédula profesional:")
                .font(.title3)
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("Licencia", text: $viewModel.license)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Text("Contraseña    :")
                .font(.title3)
                .frame(maxWidth: .infinity, alignment: .leading)
            SecureField("Contraseña", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                viewModel.createDoctor()
            }) {
                Text("Crear cuenta")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            if let success = viewModel.successMessage, !success.isEmpty {
                Text(success)
                    .foregroundColor(.green)
                    .padding(.top, 10)
            }

            if let error = viewModel.errorMessage, !error.isEmpty {
                Text(error)
                    .foregroundColor(.red)
                    .padding(.top, 10)
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    let repo = DoctorRepository()
    let useCase = CreateDoctorUseCase(repository: repo)
    let vm = CreateDoctorViewModel(createDoctorUseCase: useCase)
    return CreateDoctorView(viewModel: vm)
}
