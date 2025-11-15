//
//  LoginEntity.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 12/11/25.
//

import Foundation

// This is the user data received after logging in.
struct LoginEntity: Equatable {
    let user_id: String
    let username: String
    let role_id: Int
    let privileges: [String]
}
