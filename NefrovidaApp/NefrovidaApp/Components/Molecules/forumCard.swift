//
//  forumCard.swift
//  NefrovidaApp
//
//  Created by Iván FV on 10/11/25.
//
// Components/Molecules/forumCard.swift

import Foundation
import SwiftUI

struct forumCard: View {
    let title: String
    let description: String
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                
                Image(systemName: "person.crop.circle")
                    .font(.system(size: 50))
                    .foregroundStyle(.primary)
                    .frame(width: 68, alignment: .center)

                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(Color.nvBrand)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(description)
                        .font(.nvBody)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .frame(maxWidth: .infinity, minHeight: 92,
                   alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.white)
            )
        }
        .buttonStyle(.plain)
        .contentShape(RoundedRectangle(cornerRadius: 22))
        .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 6)
    }
}

#Preview {
    forumCard(
        title: "Foro 1",
        description: "Foro para los pacientes de Nefrovida.",
        onTap: { print("waaaaa") }
    ).padding()
}
