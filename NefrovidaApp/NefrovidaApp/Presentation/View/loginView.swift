//
//  loginView.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 11/11/25.
//

import SwiftUI

struct loginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 219/255, green: 230/255, blue: 237/255),
                    Color(red: 3/255, green: 12/255, blue: 90/255)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack() {
                NefroVidaLogo()
                    .padding(.top, 30)
                LoginForm(
                    email: $email,
                    password: $password,
                    onLogin: { print("Se inicio sesión")}
                )
                .frame(maxHeight: .infinity)
            }.padding(20)
        }
    }
}

#Preview {
    loginView()
}
