import SwiftUI

struct BottomBar: View {
    var body: some View {
        HStack{
            House()
            Spacer()
            Analysis()
            Spacer()
            Schedule()
            Spacer()
            Forum()
        }.padding(.horizontal, 22)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial)
    }
}
#Preview {
    BottomBar()
}
