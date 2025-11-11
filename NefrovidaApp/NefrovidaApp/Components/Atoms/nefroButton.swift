import SwiftUI

struct nefroButton: View {
    var text : String
    var color : Color
    var vertical : CGFloat
    var horizontal : CGFloat
    var textSize : CGFloat
    var action : () -> Void
    
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: textSize, weight: .bold))
                .padding(.vertical, vertical)
                .padding(.horizontal, horizontal)
                .background(color)
                .cornerRadius(30)
                .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
        }
        .foregroundColor(.black)
    }
}

#Preview {
    nefroButton(text: "Hello World",color:Color(red: 0.82, green: 0.94, blue: 0.97), vertical: 10, horizontal: 10,textSize: 30 ,action: {})
}
