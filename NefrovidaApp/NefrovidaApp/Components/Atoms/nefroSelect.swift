//
//  nefroField.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez
//

import SwiftUI

struct selectField: View {
    var placeholder: String
    @Binding var selection: String
    var options: [String]
    var iconName: String?
    
    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(option) {
                    selection = option
                }
            }
        } label: {
            HStack {
                Text(selection.isEmpty ? placeholder : selection)
                    .foregroundColor(selection.isEmpty ? .gray : .primary)
                    .font(.system(size: 16))
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
            }
            .frame(height: 20)
            .padding()
            .background(Color.white)
            .cornerRadius(22)
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color.cyan.opacity(0.7), lineWidth: 2)
            )
            .shadow(color: Color.cyan.opacity(0.3), radius: 6, x: 0, y: 3)
            .padding(.horizontal)
            .shadow(radius: 2)
        }
    }
}

#Preview {
    @Previewable @State var selectedGender = ""
    @Previewable @State var selectedCountry = ""
    
    VStack(spacing: 20) {
        selectField(
            placeholder: "Selecciona tu género",
            selection: $selectedGender,
            options: ["Masculino", "Femenino", "Otro"]
        )
        
        selectField(
            placeholder: "Selecciona tu país",
            selection: $selectedCountry,
            options: ["México", "Estados Unidos", "España", "Argentina"]
        )
    }
}
