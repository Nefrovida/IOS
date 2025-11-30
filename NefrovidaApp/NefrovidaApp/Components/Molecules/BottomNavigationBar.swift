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
    @Binding var isFirstLogin: Bool
    let onSelect: (Tab) -> Void

    var body: some View {
        HStack {
            Spacer()
            NavTabButton(tab: .inicio, isSelected: selectedTab == .inicio) {
                onSelect(.inicio)
            }
            Spacer()
            NavTabButton(tab: .analisis, isSelected: selectedTab == .analisis) {
                onSelect(.analisis)
            }
            if !isFirstLogin{
                Spacer()
                NavTabButton(tab: .foros, isSelected: selectedTab == .foros) {
                    onSelect(.foros)
                }
            }
            Spacer()
            NavTabButton(tab: .agenda, isSelected: selectedTab == .agenda) {
                onSelect(.agenda)
            }
            Spacer()
        }
        .padding(.vertical, 10)
        .background(Color.nvBrand)
        .edgesIgnoringSafeArea(.bottom)
    }
}
