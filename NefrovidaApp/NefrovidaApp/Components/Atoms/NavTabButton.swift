//
//  NavTabButton.swift
//  NefrovidaApp
//
//  Created by Leonardo Cervantes on 17/11/25.
//

import SwiftUI

// Atomic component: Navigation tab button
struct NavTabButton: View {
    let tab: Tab
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Image(systemName: tab.iconName)
                    .font(.system(size: 16))
                Text(tab.label)
                    .font(.system(size: 10))
            }
            .foregroundColor(isSelected ? Color.nvBrand : .white)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(isSelected ? Color.white : Color.clear)
            .cornerRadius(8)
        }
    }
}

#Preview {
    VStack {
        NavTabButton(tab: .inicio, isSelected: true) {
            print("Tab selected")
        }
        .background(Color.nvBrand)
        
        NavTabButton(tab: .agenda, isSelected: false) {
            print("Tab selected")
        }
        .background(Color.nvBrand)
    }
}
