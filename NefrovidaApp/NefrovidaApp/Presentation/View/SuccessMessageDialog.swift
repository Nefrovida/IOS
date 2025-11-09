//  SuccessMessageDialog.swift
//  NefrovidaApp
//
//  Created by Enrique Ayala on 08/11/25.
//
//  Success modal displayed after successful deletion.

import SwiftUI

struct SuccessMessageDialog: View {
    let message: String
    let onClose: () -> Void

    var body: some View {
        ZStack {
            ColorPalette.overlay
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text(NSLocalizedString("success_title", comment: "Success"))
                        .font(.headline.weight(.semibold))
                        .foregroundColor(ColorPalette.textPrimary)
                    Spacer()
                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(ColorPalette.textPrimary)
                    }
                    .accessibilityLabel(Text(NSLocalizedString("acc_close", comment: "Close")))
                }

                Text(message)
                    .font(.footnote)
                    .foregroundColor(ColorPalette.textPrimary)
            }
            .padding(Spacing.md)
            .frame(maxWidth: 300)
            .background(ColorPalette.cardPrimary)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(0.12), radius: 16, x: 0, y: 8)
        }
    }
}

#Preview {
    SuccessMessageDialog(message: "El análisis se ha borrado con éxito", onClose: {})
}
