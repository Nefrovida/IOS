//
//  ContentView.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 28/10/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @State private var showSidebar = false
    var body: some View {
        if viewModel.isLoggedIn {
            mainAppView
        } else {
            loginView(isLoggedIn: $viewModel.isLoggedIn, loggedUser: $viewModel.loggedUser)
        }
    }

    private var mainAppView: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    UpBar(showSidebar: $showSidebar)

                    currentView
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                    BottomNavigationBar(selectedTab: $viewModel.selectedTab, onSelect: { tab in
                        viewModel.selectedTab = tab
                    })
                }
                .edgesIgnoringSafeArea(.bottom)

                Sidebar(
                    isOpen: $showSidebar,
                    userName: viewModel.loggedUser?.name ?? "Usuario",
                    onLogout: {
                        viewModel.isLoggedIn = false
                    }
                ) {
                    VStack(spacing: 8) {
                        NavigationLink(destination: ProfileView()) {
                            HStack(spacing: 16) {
                                Image(systemName: "person.fill")
                                    .font(.title3)
                                    .foregroundStyle(.blue)
                                    .frame(width: 28)
                                
                                Text("Perfil")
                                    .font(.body)
                                    .foregroundStyle(.primary)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 14)
                            .background(Color.secondary.opacity(0.05))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal, 16)
                        }
                        .buttonStyle(.plain)
                        .simultaneousGesture(TapGesture().onEnded {
                            withAnimation {
                                showSidebar = false
                            }
                        })
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .edgesIgnoringSafeArea(.bottom)
    }

    @ViewBuilder
    private var currentView: some View {
        switch viewModel.selectedTab {
        case .inicio:
            HomeView(user: viewModel.loggedUser)
        case .analisis:
            ReportsView(userId: viewModel.loggedUser?.user_id ?? "")
        case .foros:
            ForumsScreen()
        case .agenda:
            CalendarView(idUser: viewModel.loggedUser?.user_id ?? "")
        }
    }
}

#Preview {
    ContentView()
}
