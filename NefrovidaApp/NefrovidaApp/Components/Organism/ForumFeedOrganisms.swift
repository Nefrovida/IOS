//
//  ForumFeedOrganisms.swift
//  NefrovidaApp
//
//  Created by Armando Fuentes Silva on 17/11/25.
//

import SwiftUI

// MARK: - Message Card
struct MessageCard: View {
    let message: ForumMessage
    @State private var isExpanded: Bool = false
    let onMoreTapped: () -> Void
    let onLikeTapped: () -> Void
    let onCommentTapped: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            MessageCardHeader(
                forumName: message.forumName,
                onMoreTapped: onMoreTapped
            )
            
            MessageCardContent(
                message: message,
                isExpanded: isExpanded,
                onToggle: { isExpanded.toggle() }
            )
            
            MessageCardFooter(
                likesCount: message.likesCount,
                commentsCount: message.commentsCount,
                onLikeTapped: onLikeTapped,
                onCommentTapped: onCommentTapped
            )
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Feed Header
struct FeedHeader: View {
    @Binding var selectedFilter: String
    let filters = ["Popular", "Recientes", "Mis Foros"]
    let onSearchTapped: () -> Void
    
    var body: some View {
        HStack {
            Menu {
                ForEach(filters, id: \.self) { filter in
                    Button(filter) {
                        selectedFilter = filter
                    }
                }
            } label: {
                HStack {
                    Text(selectedFilter)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14))
                        .foregroundColor(.primary)
                }
            }
            
            Spacer()
            
            Button(action: onSearchTapped) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20))
                    .foregroundColor(.primary)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
}

// MARK: - Empty Feed State
struct EmptyFeedState: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No hay mensajes")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Sé el primero en publicar en los foros")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
    }
}

// MARK: - Loading Feed State
struct LoadingFeedState: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Cargando mensajes...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(40)
    }
}
