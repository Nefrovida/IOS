//
//  AnalysisTypeCard.swift
//  NefrovidaApp
//
//  Created by Iván FV on 10/11/25.
//
// Components/Molecules/AnalysisTypeCard.swift

import Foundation
import SwiftUI

struct AnalysisTypeCard: View {
    let title: String
    let description: String
    var onSettings: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color.nvBrand)

                Text(description)
                    .font(.nvBody)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer(minLength: 12)

            
            buttonBar(imageName: "gearshape.fill", text: "Editar", move: onSettings)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 6)
        )
    }
}

#Preview {
    AnalysisTypeCard(
        title: "Biometría Hemática (BM)",
        description: "Descripción corta del estudio, máximo 2 renglones.",
        onSettings: { print("Abrir opciones") }
    ).padding()
}
