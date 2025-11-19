//
//  ContentViewModel.swift
//  NefrovidaApp
//
//  Created by Leonardo Cervantes on 17/11/25.
//

import Foundation
import Combine

@MainActor
final class ContentViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var loggedUser: LoginEntity?
    @Published var selectedTab: Tab = .inicio
}