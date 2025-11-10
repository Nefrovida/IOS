import SwiftUI

struct House: View {
    var body: some View {
        VStack {
            Image(systemName: "house")
            Text("Inicio")
                .font(.caption2)
        }
    }
}

#Preview(){
    House()
}
