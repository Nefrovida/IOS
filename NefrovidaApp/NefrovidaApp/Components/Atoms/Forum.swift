import SwiftUI

struct Forum: View {
    var body: some View {
        VStack {
            Button(action: goToForum) {
                VStack{
                    Label("",systemImage: "text.bubble")
                    Text("Foros");
                }
            }.padding(10)
                .foregroundColor(.black)
                
        }
    }
    
    func goToForum() {
        
    }
}

#Preview(){
    Forum()
}




