import SwiftUI

struct Schedule: View {
    var body: some View {
        VStack {
            Button(action: goToSchedule) {
                VStack{
                    Label("",systemImage: "calendar")
                    Text("Agenda");
                }
            }.padding(10)
                .foregroundColor(.black)
                
        }
    }
    
    func goToSchedule() {
        
    }
}

#Preview(){
    Schedule()
}




