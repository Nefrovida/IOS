import SwiftUI

struct buttonBar: View {
    var image : Image = Image("")
    var imageName : String = ""
    var text : String = ""
    var  move: ()-> Void
    var body: some View {
        VStack {
            Button(action: move) {
                VStack{
                    Label("",systemImage: imageName)
                    Text(text);
                }
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




