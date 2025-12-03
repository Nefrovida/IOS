//
//  SideBarItems.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 03/12/25.
//

import SwiftUI

struct SidebarMenuItem: View {
    let icon: String
    let title: String
    let badge: Int?
    let action: () -> Void
    
    init(icon: String, title: String, badge: Int? = nil, action: @escaping () -> Void) {
        self.icon = icon
        self.title = title
        self.badge = badge
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(.blue)
                    .frame(width: 28)
                
                Text(title)
                    .font(.body)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                if let badge = badge, badge > 0 {
                    Text("\(badge)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.red)
                        .clipShape(Capsule())
                }
                
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
    }
}
