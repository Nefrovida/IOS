//
//  ContentView.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 28/10/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        if viewModel.isLoggedIn {
            mainAppView
        } else {
            loginView(isLoggedIn: $viewModel.isLoggedIn, loggedUser: $viewModel.loggedUser)
        }
    }

    private var mainAppView: some View {
        VStack(spacing: 0) {
            currentView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            BottomNavigationBar(selectedTab: $viewModel.selectedTab, onSelect: { tab in
                viewModel.selectedTab = tab
            })
        }
        .edgesIgnoringSafeArea(.bottom)
    }

    @ViewBuilder
    private var currentView: some View {
        switch viewModel.selectedTab {
        case .inicio:
            NavigationStack {
                HomeView(user: viewModel.loggedUser)
            }
        case .analisis:
            AnalysisView()
        case .foros:
            ForumView(forumId: 1)
        case .agenda:
            CalendarView()
        }
    }
}

#Preview {
    ContentView()
}
