//  DeleteConfirmationDialog.swift
//  NefrovidaApp
//
//  Created by Enrique Ayala on 08/11/25.
//
//  Modal card to confirm deletion of an analysis.

import SwiftUI

struct DeleteConfirmationDialog: View {
    let titulo: String
    let onModify: () -> Void
    let onDelete: () -> Void
    let onClose: () -> Void

    var body: some View {
        ZStack {
            ColorPalette.overlay
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text(titulo)
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

                HStack(spacing: 12) {
                    Button(action: onModify) {
                        Text(NSLocalizedString("btn_modify", comment: "Modify"))
                            .font(.footnote.weight(.semibold))
                            .foregroundColor(ColorPalette.textPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(ColorPalette.textPrimary.opacity(0.1), lineWidth: 1)
                            )
                    }
                    .accessibilityHint(Text(NSLocalizedString("acc_modify_hint", comment: "Modify analysis")))

                    Button(action: onDelete) {
                        Text(NSLocalizedString("btn_delete", comment: "Delete"))
                            .font(.footnote.weight(.semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(ColorPalette.danger)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .accessibilityHint(Text(NSLocalizedString("acc_delete_hint", comment: "Delete analysis")))
                }
            }
            .padding(Spacing.md)
            .frame(maxWidth: 320)
            .background(ColorPalette.cardPrimary)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(0.12), radius: 16, x: 0, y: 8)
        }
    }
}

#Preview {
    DeleteConfirmationDialog(
        titulo: "Biometría Hemática (BM)",
        onModify: {},
        onDelete: {},
        onClose: {}
    )
}
