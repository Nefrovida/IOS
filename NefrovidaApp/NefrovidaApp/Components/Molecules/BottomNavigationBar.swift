//
//  BottomNavigationBar.swift
//  NefrovidaApp
//
//  Created by Leonardo Cervantes on 17/11/25.
//

import SwiftUI

// Molecule component: Bottom navigation bar composed of NavTabButton atoms
struct BottomNavigationBar: View {
    @Binding var selectedTab: Tab
    let onSelect: (Tab) -> Void

    var body: some View {
        HStack {
            Spacer()
            NavTabButton(tab: .inicio, isSelected: selectedTab == .inicio) {
                onSelect(.inicio)
            }
            Spacer()
            NavTabButton(tab: .servicios, isSelected: selectedTab == .servicios) {
                onSelect(.servicios)
            }
            Spacer()
            NavTabButton(tab: .analisis, isSelected: selectedTab == .analisis) {
                onSelect(.analisis)
            }
            Spacer()
            NavTabButton(tab: .foros, isSelected: selectedTab == .foros) {
                onSelect(.foros)
            }
            Spacer()
            NavTabButton(tab: .agenda, isSelected: selectedTab == .agenda) {
                onSelect(.agenda)
            }
            Spacer()
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 12) 
        .background(Color.nvBrand)
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    BottomNavigationBar(selectedTab: .constant(.inicio)) { tab in
        print("Selected: \(tab)")
    }
}