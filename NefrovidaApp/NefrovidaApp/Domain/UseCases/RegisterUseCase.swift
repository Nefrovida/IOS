//
//  RegisterUseCases.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 01/12/25.
//

import Foundation

class RegisterUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func execute(request: RegisterRequest) async throws -> RegisterResponse {
        try await repository.register(request: request)
    }
}
