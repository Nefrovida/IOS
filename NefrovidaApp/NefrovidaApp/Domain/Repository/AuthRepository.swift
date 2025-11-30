//
//  AuthRepositoryProtocol.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 12/11/25.
//

import Foundation

// Protocol defining the actions to log in
protocol AuthRepository {
    // Username and password are entered, and if successful, the user's data is received.
    func login(username: String, password: String) async throws -> LoginEntity
}

protocol UserRepository {
    func fetchFirstLogin(for userId: String) async throws -> Bool
}
