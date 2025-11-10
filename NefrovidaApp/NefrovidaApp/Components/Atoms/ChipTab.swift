import SwiftUI

struct ChipTab: View {
    let title: String
    let isSelected: Bool
    
    var body: some View {
        Button(action: goToOtherView) {
            Text(title)
                .font(.nvBody)
                .padding(.vertical, 8)
                .padding(.horizontal, 14)
                .background(
                    Capsule()
                        .strokeBorder(isSelected ? Color.primary : Color.gray.opacity(0.35), lineWidth: 1)
                        .background(Capsule().fill(isSelected ? Color.gray.opacity(0.12) : .clear))
                )
        }.foregroundColor(.black)
    }
    func goToOtherView() {
        
    }
}

#Preview {
    ChipTab(title: "test", isSelected: true)
}
