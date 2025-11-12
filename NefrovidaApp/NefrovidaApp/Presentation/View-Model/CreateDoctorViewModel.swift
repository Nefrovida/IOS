//
//  CreateDoctorViewModel.swift
//  NefrovidaApp
//
//  Created by Ana Paola Hernandez  on 11/11/25.
//

import Foundation
import Combine

class CreateDoctorViewModel: ObservableObject {
    @Published var name = ""
    @Published var specialty = ""
    @Published var license = ""
    @Published var password = ""
    @Published var successMessage: String?
    @Published var errorMessage: String?

    private let createDoctorUseCase: CreateDoctorUseCaseProtocol

    init(createDoctorUseCase: CreateDoctorUseCaseProtocol) {
        self.createDoctorUseCase = createDoctorUseCase
    }

    func createDoctor() {
        let doctor = Doctor(
            id: UUID().uuidString,
            name: name,
            specialty: specialty,
            license: license,
            password: password
        )

        createDoctorUseCase.execute(doctor: doctor) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.successMessage = "Doctor creado con éxito"
                    self?.errorMessage = nil
                    self?.clearFields()
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.successMessage = nil
                }
            }
        }
    }

    private func clearFields() {
        name = ""
        specialty = ""
        license = ""
        password = ""
    }
}
