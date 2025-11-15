import SwiftUI

struct nefroButton: View {
    var text : String
    var color : Color
    var textColor : Color = .black
    var vertical : CGFloat
    var horizontal : CGFloat
    var hasStroke : Bool = false
    var textSize : CGFloat
    var action : () -> Void
    
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: textSize, weight: .bold))
                .foregroundStyle(textColor)
                .padding(.vertical, vertical)
                .padding(.horizontal, horizontal)
                .background(color)
                .cornerRadius(30)
                .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
        }.overlay (
            // If you want the rounded stroke, use the variable hasStroke
            Group {
                if hasStroke {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.cyan.opacity(0.7), lineWidth: 2)
                }
            }
        )
    }
}

// A preview to visualize the aplication of the nefroButton with stroke and with out it
#Preview {
    nefroButton(text: "Hello World",color:Color(red: 0.82, green: 0.94, blue: 0.97), vertical: 10, horizontal: 10,textSize: 30 ,action: {})
    
    nefroButton(text: "Hello World",color: .white, vertical: 10, horizontal: 10, hasStroke: true, textSize: 30 ,action: {}) .padding(20)
}
