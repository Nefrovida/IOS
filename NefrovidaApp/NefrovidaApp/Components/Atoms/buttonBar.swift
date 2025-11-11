import SwiftUI

struct buttonBar: View {
    var imageName : String = ""
    var text : String = ""
    var move: ()-> Void
    var body: some View {
        VStack {
            Button(action: move) {
                VStack{
                    Image(systemName: imageName)
                    Text(text);
                }
                .frame(alignment: .center)
            }.padding(10)
                .foregroundColor(.black)
                
        }
    }

}

#Preview {
    buttonBar(imageName: "text.bubble", text: "foro") {
        print("go")
    }
}




