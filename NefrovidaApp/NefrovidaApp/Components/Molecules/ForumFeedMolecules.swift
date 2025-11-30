///
//  ForumFeedMolecules.swift
//  NefrovidaApp
//
//  Created by Armando Fuentes Silva on 17/11/25.
//

import SwiftUI

// MARK: - Message Card Header
struct MessageCardHeader: View {
    let authorName: String
    let forumName: String?
    let onMoreTapped: () -> Void
    
    var body: some View {
        HStack {
            UserAvatar(imageUrl: nil, size: 40)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(authorName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                if let forumName = forumName {
                    ForumBadge(forumName: forumName)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            MoreOptionsButton(action: onMoreTapped)
        }
    }
}

// MARK: - Message Card Content
struct MessageCardContent: View {
    let message: ForumMessageEntity
    let isExpanded: Bool
    let onToggle: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(isExpanded ? message.content : truncatedContent)
                .font(.system(size: 15))
                .foregroundColor(.primary)
                .lineLimit(isExpanded ? nil : 4)
            
            if message.content.count > 200 && !isExpanded {
                Button(action: onToggle) {
                    VerMasText()
                }
            }
        }
    }
    
    private var truncatedContent: String {
        if message.content.count > 200 {
            return String(message.content.prefix(200)) + "..."
        }
        return message.content
    }
}

// MARK: - Message Card Footer
struct MessageCardFooter: View {
    let likesCount: Int
    let commentsCount: Int
    let onLikeTapped: () -> Void
    let onCommentTapped: () -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            InteractionButton(
                icon: "hand.thumbsup",
                count: likesCount,
                isActive: false,
                action: onLikeTapped
            )
            
            InteractionButton(
                icon: "message",
                count: commentsCount,
                isActive: false,
                action: onCommentTapped
            )
            
            Spacer()
        }
        .padding(.top, 8)
    }
}

// MARK: - Floating Action Buttons Group
struct FloatingActionButtons: View {
    let onNewPostTapped: () -> Void
    let onEditTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            FloatingActionButton(icon: "plus", action: onNewPostTapped)
        }
    }
}
