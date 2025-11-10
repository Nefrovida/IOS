import SwiftUI

struct Schedule: View {
    var body: some View {
        VStack {
            Image(systemName: "calendar"); Text("Agenda").font(.caption2).fontWeight(.semibold)
        }
    }
}

#Preview(){
    Schedule()
}
