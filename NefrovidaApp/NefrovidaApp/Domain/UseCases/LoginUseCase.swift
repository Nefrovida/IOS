//
//  LoginUseCase.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 12/11/25.
//

import Foundation

// Use case that manages the login logic
final class LoginUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    // Returns user data if the username and password are correct
    func execute(username: String, password: String) async throws -> LoginEntity {
        return try await repository.login(username: username, password: password)
    }
}
