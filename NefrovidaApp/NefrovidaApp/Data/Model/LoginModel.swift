//
//  LoginModel.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 12/11/25.
//

import Foundation

// Used to decode the JSON response from the server
nonisolated struct LoginResponse: Decodable {
    // Contains user data
    let user: LoginModel
}

//  Model representing the user based on the received JSON
nonisolated struct LoginModel: Decodable, Sendable {
    let user_id: String
    let name: String
    let username: String
    let role_id: Int
    let privileges: [String]?
}

nonisolated struct FirstLoginResponse: Decodable, Sendable {
    let isFirstLogin: Bool
}
