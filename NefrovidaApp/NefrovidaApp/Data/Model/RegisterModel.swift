//
//  RegisterModel.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 01/12/25.
//

import Foundation

nonisolated struct RegisterRequest: Codable {
    let name: String
    let parentLastName: String
    let maternalLastName: String?
    let phoneNumber: String
    let username: String
    let password: String
    let birthday: String
    let gender: String
    let roleId: Int
    let curp: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case parentLastName = "parent_last_name"
        case maternalLastName = "maternal_last_name"
        case phoneNumber = "phone_number"
        case username
        case password
        case birthday
        case gender
        case roleId = "role_id"
        case curp
    }
}

nonisolated struct RegisterResponse: Codable {
    let user: UserData
    
    struct UserData: Codable {
        let userId: String
        let name: String
        let username: String
        let roleId: Int
        
        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
            case name
            case username
            case roleId = "role_id"
        }
    }
}
