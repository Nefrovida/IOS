//
//  ForumFeedAtoms.swift
//  NefrovidaApp
//
//  Created by Armando Fuentes Silva on 17/11/25.
//

import SwiftUI

// MARK: - User Avatar
struct UserAvatar: View {
    let imageUrl: String?
    let size: CGFloat
    
    var body: some View {
        Circle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: size, height: size)
            .overlay(
                Image(systemName: "person.fill")
                    .font(.system(size: size * 0.5))
                    .foregroundColor(.gray)
            )
    }
}

// MARK: - Forum Badge
struct ForumBadge: View {
    let forumName: String
    
    var body: some View {
        Text(forumName)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(.primary)
    }
}

// MARK: - Interaction Button (Like/Comment)
struct InteractionButton: View {
    let icon: String
    let count: Int
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                Text("\(count)")
                    .font(.system(size: 14))
            }
            .foregroundColor(isActive ? .blue : .gray)
        }
    }
}

// MARK: - More Options Button
struct MoreOptionsButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "ellipsis")
                .font(.system(size: 18))
                .foregroundColor(.gray)
                .rotationEffect(.degrees(90))
        }
    }
}

// MARK: - Ver más Text
struct VerMasText: View {
    var body: some View {
        Text("Ver más")
            .font(.system(size: 14))
            .foregroundColor(.blue)
    }
}

// MARK: - Floating Action Button
struct FloatingActionButton: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(Color.blue)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
    }
}
