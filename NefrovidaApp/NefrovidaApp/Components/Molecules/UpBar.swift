import SwiftUI

struct UpBar: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .frame(height: 75)
                .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 6)
            HStack{
                NavigationLink(destination: ProfileView()) {
                    VStack {
                        Image(systemName: "person.crop.circle")
                        Text("")
                    }
                    .padding(10)
                    .foregroundColor(.black)
                }
                .font(.system(size:26))
                NefroVidaLogo()
                buttonBar(imageName:"bell", text: ""){ print("Notificaciones")}
                    .font(.system(size:26))
            }.padding(.horizontal, 22)
                .padding(.vertical, 10)
        }
    }
}
#Preview {
    UpBar()
}
