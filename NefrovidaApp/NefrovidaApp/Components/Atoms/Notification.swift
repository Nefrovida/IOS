import SwiftUI

struct Notification: View {
    var body: some View {
        Button(action:goToNotification){
            Image(systemName: "bell")
        }.foregroundColor(.black)
    }
    func goToNotification(){
        
    }
}

#Preview {
    Notification()
}
