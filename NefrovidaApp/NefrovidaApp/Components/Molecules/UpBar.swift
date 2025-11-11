import SwiftUI

struct UpBar: View {
    var body: some View {
        HStack{
            buttonBar(imageName: "person.crop.circle", text: ""){ print("hola")}
                .font(.system(size:26))
            NefroVidaLogo()
            buttonBar(imageName:"bell", text: ""){ print("hola")}
                .font(.system(size:26))
        }.padding(.horizontal, 22)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial)
    }
}
#Preview {
    UpBar()
}
