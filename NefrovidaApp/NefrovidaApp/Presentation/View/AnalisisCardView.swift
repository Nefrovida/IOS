//  AnalisisCardView.swift
//  NefrovidaApp
//
//  Created by Enrique Ayala on 08/11/25.
//
//  Reusable card view for displaying an individual analysis.

import SwiftUI

struct AnalisisCardView: View {
    let item: Analisis
    let onOptionsTapped: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: Spacing.md) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.titulo)
                    .font(.headline.weight(.semibold))
                    .foregroundColor(ColorPalette.textPrimary)
                    .accessibilityLabel(Text("\(item.titulo)"))
                Text(item.fechaCorta)
                    .font(.footnote)
                    .foregroundColor(ColorPalette.textSecondary)
                    .accessibilityLabel(Text(item.fechaCorta))
            }
            Spacer()
            Button(action: onOptionsTapped) {
                Image(systemName: "gearshape")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(ColorPalette.primary) // interactive = primary
            }
            .accessibilityLabel(Text(NSLocalizedString("acc_options", comment: "Options")))
            .accessibilityHint(Text(NSLocalizedString("acc_options_hint", comment: "Open options to modify or delete")))
        }
        .padding(Spacing.md)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Preview
#Preview {
    let sample = Analisis(id: "1", titulo: "Biometría Hemática (BM)", fecha: Date(), tipo: "Laboratorio")
    return AnalisisCardView(item: sample, onOptionsTapped: {})
        .padding()
        .background(Color(.systemGroupedBackground))
}
