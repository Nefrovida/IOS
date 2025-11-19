//
//  QuestionField.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 11/11/25.
//

import SwiftUI

enum QuestionType {
    case choice(options: [String])
    case text
    case number
    case date
    case select(options: [String])
}

struct questionField: View {
    let question: String
    let type: QuestionType
    
    // Usamos un binding genérico tipo String para simplicidad
    @Binding var answer: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(question)
                .font(.subheadline)
                .foregroundColor(.black)
                .padding(.horizontal)
            
            switch type {
            case .choice(let options):
                HStack(spacing: 8) {
                    ForEach(options, id: \.self) { option in
                        Button(action: { answer = option }) {
                            Text(option)
                                .font(.footnote)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(answer == option ? Color.cyan.opacity(0.3) : Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.cyan.opacity(0.6), lineWidth: 1)
                                )
                        }
                    }
                }
                .padding(.horizontal)
                
            case .text:
                TextField("Escribe tu respuesta...", text: $answer)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
            case .number:
                TextField("Ingresa un número", text: $answer)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
            case .date:
                DatePicker("Selecciona fecha", selection: Binding(
                    get: {
                        let dateFormatter = ISO8601DateFormatter()
                        return dateFormatter.date(from: answer) ?? Date()
                    },
                    set: { newDate in
                        let formatter = ISO8601DateFormatter()
                        answer = formatter.string(from: newDate)
                    }
                ), displayedComponents: .date)
                .padding(.horizontal)
                
            case .select(let options):
                Picker(selection: $answer, label: Text(answer.isEmpty ? "Selecciona una opción" : answer)) {
                    ForEach(options, id: \.self) { opt in
                        Text(opt).tag(opt)
                    }
                }
                .pickerStyle(.menu)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.cyan.opacity(0.5))
                )
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    @Previewable @State var respuesta = ""
    VStack(spacing: 16) {
        questionField(
            question: "¿Padece diabetes mellitus?",
            type: .choice(options: ["Sí", "No", "Lo desconoce"]),
            answer: $respuesta
        )
        questionField(
            question: "¿Cuál es su ocupación?",
            type: .text,
            answer: $respuesta
        )
        questionField(
            question: "Seleccione su fecha de nacimiento",
            type: .date,
            answer: $respuesta
        )
    }
    .padding()
}
