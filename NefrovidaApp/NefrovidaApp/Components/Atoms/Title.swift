//
//  Title.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 10/11/25.
//
import SwiftUI

struct Title: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(Color(red: 1/255, green: 12/255, blue: 94/255))
            .multilineTextAlignment(.leading)
            .padding(.vertical, 8)
    }
}

#Preview {
    Title(text: "Hola")
}
