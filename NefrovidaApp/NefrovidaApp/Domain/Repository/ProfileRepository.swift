//
//  ProfileRepository.swift
//  NefrovidaApp
//
//  Created by Enrique Ayala on 12/01/25.
//

import Foundation

nonisolated protocol ProfileRepository: Sendable {
    func getMyProfile() async throws -> ProfileEntity
    func updateMyProfile(data: UpdateProfileDTO) async throws -> ProfileEntity
    func changePassword(data: ChangePasswordDTO) async throws -> Bool
}
