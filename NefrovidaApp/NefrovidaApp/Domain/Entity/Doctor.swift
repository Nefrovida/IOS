//
//  Doctor.swift
//  NefrovidaApp
//
//  Created by Ana Paola Hernandez  on 11/11/25.
//

struct Doctor: Identifiable, Codable {
    let id: String
    var name: String
    var specialty: String
    var license: String
    var password: String
}
