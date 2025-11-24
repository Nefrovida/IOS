//
//  FeedCard.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 23/11/25.
//
import SwiftUI

struct FeedCard: View {
    let item: ForumFeedItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.title3)
                    .foregroundColor(.gray)

                Text(item.forumName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }

            Text(item.content)
                .foregroundColor(.primary)
                .font(.body)
                .lineLimit(4)

            HStack(spacing: 18) {
                Label("\(item.likes)", systemImage: "hand.thumbsup")
                Label("\(item.replies)", systemImage: "bubble.left")
                
                Spacer()
                
                Text("Ver más")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).stroke(.gray.opacity(0.2)))
    }
}
