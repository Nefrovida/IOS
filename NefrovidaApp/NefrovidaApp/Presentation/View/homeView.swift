//
//  homeView.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 12/11/25.
//

import SwiftUI

struct HomeView: View {
    let user: LoginEntity?
    
    var body: some View {
        VStack {
            Text("Bienvenido, \(user?.username ?? "")")
        }
    }
}
