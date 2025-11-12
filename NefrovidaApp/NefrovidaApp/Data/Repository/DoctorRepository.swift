//
//  DoctorRepository.swift
//  NefrovidaApp
//
//  Created by Ana Paola Hernandez  on 11/11/25.
//

import Foundation

class DoctorRepository: DoctorRepositoryProtocol {
    func create(doctor: Doctor, completion: @escaping (Result<Doctor, Error>) -> Void) {
        // Simulación de creación del doctor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(.success(doctor))
        }
    }
}
