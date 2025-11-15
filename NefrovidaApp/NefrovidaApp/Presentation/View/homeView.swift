//
//  homeView.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 12/11/25.
//

import SwiftUI

import SwiftUI

struct HomeView: View {
    let user: LoginEntity?
    
    var body: some View {
        VStack(spacing: 0){
            UpBar()
            
            VStack {
                Text("Bienvenido, \(user?.username ?? "")")
                    .font(.title)
                    .padding()
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
        BottomBar()
    }
}
#Preview {
    HomeView(
        user: LoginEntity(
            user_id: "12345-ABCDE",
            username: "Emilio",
            role_id: 3,
            privileges: []
        )
    )
}
