//
//  button.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 10/11/25.
//

import SwiftUI

struct PrimaryButton: View {           // ojo luego este nombre lo vas a cambiar a algo tipo PrimaryButton -> porque ButtonStyle choca con SwiftUI ButtonStyle real
    var text : String
    var color : Color
    var vertical : CGFloat
    var horizontal : CGFloat
    var action : () -> Void
    
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 20, weight: .bold))
                .padding(.vertical, vertical)
                .padding(.horizontal, horizontal)
                .background(color)
                .cornerRadius(30) // super redondo
                .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
        }
        .foregroundColor(.black)
    }
}

#Preview {
    PrimaryButton(text: "Hello World",color:Color(red: 0.82, green: 0.94, blue: 0.97), vertical: 10, horizontal: 10 ,action: {})
}
