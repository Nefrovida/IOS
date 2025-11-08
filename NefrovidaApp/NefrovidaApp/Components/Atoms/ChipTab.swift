//
//  ChipTab.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 08/11/25.
//

// Components/Atoms/ChipTab.swift
import SwiftUI

struct ChipTab: View {
    let title: String
    let isSelected: Bool

    var body: some View {
        Text(title)
            .font(.subheadline)
            .padding(.vertical, 8)
            .padding(.horizontal, 14)
            .background(
                Capsule().strokeBorder(isSelected ? Color.primary : Color.gray.opacity(0.4), lineWidth: 1)
            )
    }
}
