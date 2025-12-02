//
//  nefroDate.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 02/12/25.
//

import SwiftUI

struct datePickerField: View {
    var text: String
    var placeholder: String
    @Binding var date: Date
    var iconName: String?
    
    var body: some View {
        HStack {
            Text(text)
                .foregroundColor(Color.gray.opacity(0.5))
            DatePicker(
                "",
                selection: $date,
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            .labelsHidden()
            .font(.system(size: 16))
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

#Preview {
    @Previewable @State var birthDate = Date()
    @Previewable @State var appointmentDate = Date()
    
    VStack(spacing: 20) {
        datePickerField(
            text: "Fecha de naciemiento",
            placeholder: "Fecha de nacimiento",
            date: $birthDate
        )
    }
}
