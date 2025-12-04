//
//  ChangePasswordUseCase.swift
//  NefrovidaApp
//
//  Created by Enrique Ayala on 12/01/25.
//

import Foundation

struct ChangePasswordUseCase: Sendable {
    let repository: ProfileRepository
    
    func execute(data: ChangePasswordDTO) async throws -> Bool {
        return try await repository.changePassword(data: data)
    }
}
