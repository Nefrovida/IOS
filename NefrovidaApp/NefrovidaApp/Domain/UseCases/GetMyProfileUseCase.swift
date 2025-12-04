//
//  GetMyProfileUseCase.swift
//  NefrovidaApp
//
//  Created by Enrique Ayala on 12/01/25.
//

import Foundation

struct GetMyProfileUseCase: Sendable {
    let repository: ProfileRepository
    
    func execute() async throws -> ProfileEntity {
        return try await repository.getMyProfile()
    }
}
