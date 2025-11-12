//
//  ContentView.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 28/10/25.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        // Crear la cadena de dependencias MVVM
        let repository = DoctorRepository()
        let useCase = CreateDoctorUseCase(repository: repository)
        let viewModel = CreateDoctorViewModel(createDoctorUseCase: useCase)

        // Mostrar la vista de creación de doctores
        CreateDoctorView(viewModel: viewModel)
    }
}

#Preview {
    ContentView()
}
