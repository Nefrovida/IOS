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
        NavigationStack {
            VStack(spacing: 0) {
                UpBar()
                VStack(spacing: 20) {
                    Text("Bienvenido, \(user?.name ?? "")")
                        .font(.title)
                        .padding(.top, 20)
                    
                    NavigationLink(
                        destination: appointmentView(appointmentId: 1,
                                                     userId: user?.user_id ?? "")
                    ) {
                        Text("Agendar cita")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.horizontal, 24)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                BottomBar()
            }
        }
    }
}

#Preview {
    HomeView(
        user: LoginEntity(
            user_id: "12345-ABCDE",
            name: "EmilioL",
            username: "Emilio",
            role_id: 3,
            privileges: []
        )
    )
}
