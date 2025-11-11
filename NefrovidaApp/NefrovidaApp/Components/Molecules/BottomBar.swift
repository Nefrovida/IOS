import SwiftUI

struct BottomBar: View {
    var body: some View {
        HStack{
            buttonBar(imageName:"house", text: "Inicio"){ print("hola")}
            Spacer()
            buttonBar(imageName:"testtube.2", text: "Analisis"){ print("hola")}
            Spacer()
            buttonBar(imageName:"calendar", text: "Agenda"){ print("hola")}
            Spacer()
            buttonBar(imageName:"text.bubble", text: "Foros"){ print("hola")}
        }.padding(.horizontal, 22)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial)
    }
}
#Preview {
    BottomBar()
}
