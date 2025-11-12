//
//  loginView.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 11/11/25.
//

import SwiftUI

struct loginView: View {
    // Variables to be able to display the view
    // @StateObject private var viewModel = LoginViewModel()
    @State private var user: String = ""
    @State private var password: String = ""
    var body: some View {
        ZStack {
            // The background gradient colors is defined
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
                // It's called the nefrovida logo
                NefroVidaLogo()
                    .padding(.top, 30)
                // The loginForm molecule is used
                LoginForm(
                    user: $user,
                    password: $password,
                    onLogin: { print("Se inicio sesión")}
                )
                .frame(maxHeight: .infinity)
            }.padding(20)
        }
    }
}

// A preview to visualize the view of the loginView
#Preview {
    loginView()
}
