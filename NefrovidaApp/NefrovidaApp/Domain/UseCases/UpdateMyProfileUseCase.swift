//
//  UpdateMyProfileUseCase.swift
//  NefrovidaApp
//
//  Created by Enrique Ayala on 12/01/25.
//

import Foundation

struct UpdateMyProfileUseCase: Sendable {
    let repository: ProfileRepository
    
    func execute(data: UpdateProfileDTO) async throws -> ProfileEntity {
        return try await repository.updateMyProfile(data: data)
    }
}
