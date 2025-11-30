import SwiftUI

struct BottomBar: View {
    
    var idUser : String
    var body: some View {
        HStack{
            buttonBar(imageName:"house", text: "Inicio"){ print("Inicio")}
            Spacer()
            buttonBar(imageName:"cross.case", text: "Servicios"){ print("Servicios")}
            Spacer()
            buttonBar(imageName:"testtube.2", text: "Analisis"){ print("Analisis")}
            Spacer()
            buttonBar(imageName:"calendar", text: "Agenda"){ print("Agenda")}
            Spacer()
            buttonBar(imageName:"text.bubble", text: "Foros"){ print("Foros")}
        }.padding(.horizontal, 22)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial)
    }
}
#Preview {
    BottomBar(idUser:"3737")
}
