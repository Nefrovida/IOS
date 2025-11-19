//
//  AnalysisTypeCard.swift
//  NefrovidaApp
//
//  Created by Iván FV on 10/11/25.
//
// Components/Molecules/AnalysisTypeCard.swift

import SwiftUI

struct AnalysisTypeCard: View {
    let title: String
    let description: String
    let costoComunidad: String?
    let costoGeneral: String?
    
    var isAnalysis: Bool = false
    var onSettings: () -> Void  // Callback cuando se selecciona servicio

    var body: some View {
        HStack(alignment: .center, spacing: 16) {

            // ---- TEXT SECTION ----
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(Color.nvBrand)

                Text(description)
                    .font(.nvBody)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                // 🧾 COST SECTION
                VStack(alignment: .leading, spacing: 4) {
                    if let general = costoGeneral {
                        Text("Externo: $\(general)")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(.gray)
                    }
                    if let community = costoComunidad {
                        Text("Comunidad: $\(community)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.nvBrand)
                    }
                }
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 6)
        )
    }
}

#Preview {
    VStack(spacing: 16) {
        AnalysisTypeCard(
            title: "Biometría Hemática",
            description: "Estudio general de sangre.",
            costoComunidad: "150.00",
            costoGeneral: "250.00",
            isAnalysis: true,
            onSettings: { print("Selecciona análisis") }
        )
        
        AnalysisTypeCard(
            title: "Consulta General",
            description: "Agenda con médico general",
            costoComunidad: "300",
            costoGeneral: "500",
            isAnalysis: false,
            onSettings: { print("Selecciona consulta") }
        )
    }
    .padding()
}
