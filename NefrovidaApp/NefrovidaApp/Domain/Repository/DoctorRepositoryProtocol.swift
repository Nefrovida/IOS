//
//  DoctorRepositoryProtocol.swift
//  NefrovidaApp
//
//  Created by Ana Paola Hernandez  on 11/11/25.
//

import Foundation

protocol DoctorRepositoryProtocol {
    func create(doctor: Doctor, completion: @escaping (Result<Doctor, Error>) -> Void)
}
