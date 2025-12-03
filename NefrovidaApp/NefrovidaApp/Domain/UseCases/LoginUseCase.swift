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

final class isLogginUsesCase {
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func execute(userId: String) async throws -> Bool {
        return try await repository.fetchFirstLogin(for: userId)
    }
}
