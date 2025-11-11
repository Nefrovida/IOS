//
//  nefroPop.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 11/11/25.
//

import SwiftUI

struct InfoPopupAtom: View {
    // Parámetros para reutilización
    var title: String
    var description: String
    var subtitle: String
    var indication: String
    var buttonText: String
    var buttonAction: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // Título principal
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            // Descripción principal
            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 8)
            
            // Subtítulo + indicación
            VStack(spacing: 4) {
                Text(subtitle)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Text(indication)
                    .font(.body)
                    .foregroundColor(.gray)
            }
            
            // Botón (usando tu átomo nefroButton)
            nefroButton(
                text: buttonText,
                color: .white,
                vertical: 10,
                horizontal: 50,
                textSize: 18,
                action: buttonAction
            ).overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color.cyan.opacity(0.7), lineWidth: 2))
        }
        .padding()
        .background(Color(red: 0.85, green: 0.95, blue: 0.97))
        .cornerRadius(20)
        .shadow(radius: 8)
        .padding(.horizontal, 30)
    }
}

#Preview {
    InfoPopupAtom(
        title: "¡Importante!",
        description: """
        ¿Para qué sirve este estudio?
        Evaluar información de las células presentes en la sangre, como los glóbulos rojos encargados de transportar oxígeno y los glóbulos blancos que combaten infecciones y plaquetas y detienen hemorragias mediante la formación de coágulos.
        """,
        subtitle: "Indicaciones para el examen",
        indication: "Ayuno de 4 horas.",
        buttonText: "Continuar",
        buttonAction: { print("Botón presionado") }
    )
}
