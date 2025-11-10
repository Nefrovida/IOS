// Components/Atoms/ChipTab.swift
import SwiftUI

struct ChipTab: View {
    let title: String
    let isSelected: Bool

    var body: some View {
        Text(title)
            .font(.nvBody)
            .padding(.vertical, 8)
            .padding(.horizontal, 14)
            .background(
                Capsule()
                    .strokeBorder(isSelected ? Color.primary : Color.gray.opacity(0.35), lineWidth: 1)
                    .background(Capsule().fill(isSelected ? Color.gray.opacity(0.12) : .clear))
            )
    }
}

#Preview {
    ChipTab(title: "test", isSelected: true)
}
