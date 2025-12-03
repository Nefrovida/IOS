import SwiftUI

struct UpBar: View {
    var showSidebar: Binding<Bool>? = nil
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .frame(height: 75)
                .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 6)

            if let showSidebar = showSidebar {
                HStack {
                    Button(action: {
                        withAnimation {
                            showSidebar.wrappedValue.toggle()
                        }
                    }) {
                        Image(systemName: "person.crop.circle")
                            .font(.system(size: 26))
                            .padding(10)
                            .foregroundColor(.black)
                    }
                    .font(.system(size: 26))

                    NefroVidaLogo()

                    buttonBar(imageName: "bell", text: "") {
                        print("Notificaciones")
                    }
                    .font(.system(size: 26))
                }
                .padding(.horizontal, 22)
                .padding(.vertical, 10)
            } else {
                HStack {
                    Spacer()
                    NefroVidaLogo()
                    Spacer()
                }
                .padding(.horizontal, 22)
                .padding(.vertical, 10)
            }
        }
    }
}
