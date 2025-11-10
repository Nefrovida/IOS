import SwiftUI

struct Profile: View
{
    var body: some View {
        Button(action : goToProfile){
            Image(systemName: "person.crop.circle")
        }.foregroundColor(.black)
    }
    func goToProfile(){
        
    }
}

#Preview {
    Profile()
}
