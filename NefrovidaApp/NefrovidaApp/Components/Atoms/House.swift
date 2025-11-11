import SwiftUI

struct House: View {
    var body: some View {
        VStack {
            Button(action: goToHome) {
                VStack{
                    Label("",systemImage: "house")
                    Text("Inicio");
                }
            }.padding(10)
                .foregroundColor(.black)
                
        }
    }
    
    func goToHome() {
        
    }
}

#Preview(){
    House()
}




