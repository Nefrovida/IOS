//
//  ProfileModel.swift
//  NefrovidaApp
//
//  Created by Enrique Ayala on 12/01/25.
//

import Foundation

// MARK: - Profile DTO
nonisolated struct ProfileDTO: Decodable, Sendable {
    let id: String
    let name: String
    let username: String
    let email: String?
    let phoneNumber: String?
    let roleName: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case name
        case username
        case email
        case phoneNumber = "phone_number"
        case roleName = "role_name"
    }
}

// MARK: - Update Profile DTO
nonisolated struct UpdateProfileDTO: Encodable, Sendable {
    let name: String?
    let phoneNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case phoneNumber = "phone_number"
    }
}

// MARK: - Change Password DTO
nonisolated struct ChangePasswordDTO: Encodable, Sendable {
    let currentPassword: String
    let newPassword: String
    let confirmNewPassword: String
    
    enum CodingKeys: String, CodingKey {
        case currentPassword = "currentPassword"
        case newPassword = "newPassword"
        case confirmNewPassword = "confirmNewPassword"
    }
}
// MARK: - Profile Update Response
nonisolated struct ProfileUpdateResponse: Decodable, Sendable {
    let message: String
    let data: ProfileDTO
}
