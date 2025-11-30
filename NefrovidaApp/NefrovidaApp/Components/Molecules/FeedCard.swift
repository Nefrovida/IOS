//
//  FeedCard.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 23/11/25.
//
import SwiftUI

struct FeedCard: View {
    let item: ForumFeedItem
    let onRepliesTapped: () -> Void
    
    @State private var isExpanded = false
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: "person.circle.fill")
                    .font(.title3)
                    .foregroundColor(.gray)

                Text(item.authorName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Spacer()
            }
            
            Text(isExpanded ? item.content : truncatedContent)
                .foregroundColor(.primary)
                .font(.body)
                .lineLimit(isExpanded ? nil : 4)

            HStack(spacing: 18) {
                Label("\(item.likes)", systemImage: "hand.thumbsup")

                Button {
                    onRepliesTapped()
                } label: {
                    Label("\(item.replies)", systemImage: "bubble.left")
                }
                Spacer()

                if item.content.count > 200 && !isExpanded {
                    Button {
                        isExpanded.toggle()
                    } label: {
                        Text("Ver más")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).stroke(.gray.opacity(0.2)))
    }

    private var truncatedContent: String {
        if item.content.count > 200 {
            return String(item.content.prefix(200)) + "..."
        }
        return item.content
    }
}
