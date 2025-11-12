//
//  CreateDoctorUseCase.swift
//  NefrovidaApp
//
//  Created by Ana Paola Hernandez  on 11/11/25.
//

import Foundation

protocol CreateDoctorUseCaseProtocol {
    func execute(doctor: Doctor, completion: @escaping (Result<Doctor, Error>) -> Void)
}

class CreateDoctorUseCase: CreateDoctorUseCaseProtocol {
    private let repository: DoctorRepositoryProtocol

    init(repository: DoctorRepositoryProtocol) {
        self.repository = repository
    }

    func execute(doctor: Doctor, completion: @escaping (Result<Doctor, Error>) -> Void) {
        // Validación de campos requeridos
        guard !doctor.name.isEmpty,
              !doctor.specialty.isEmpty,
              !doctor.license.isEmpty,
              !doctor.password.isEmpty else {
            completion(.failure(NSError(domain: "Validation", code: 400, userInfo: [NSLocalizedDescriptionKey: "Todos los campos son obligatorios."])))
            return
        }

        repository.create(doctor: doctor, completion: completion)
    }
}
