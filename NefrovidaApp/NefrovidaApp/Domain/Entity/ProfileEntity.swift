//
//  ProfileEntity.swift
//  NefrovidaApp
//
//  Created by Enrique Ayala on 12/01/25.
//

import Foundation

struct ProfileEntity: Identifiable, Equatable, Sendable {
    let id: String
    let name: String
    let username: String
    let email: String?
    let phoneNumber: String?
    let roleName: String?
}
