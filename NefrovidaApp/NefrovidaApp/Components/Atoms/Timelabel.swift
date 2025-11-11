import SwiftUI

struct TimeLabel: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.nvBody)
            .frame(width: 48, alignment: .trailing)
            .foregroundStyle(.secondary)
    }
}

#Preview {
    TimeLabel(text: "12:34")
}
