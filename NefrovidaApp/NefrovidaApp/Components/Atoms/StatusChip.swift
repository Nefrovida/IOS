//
//  StatusChip.swift
//  NefrovidaApp
//
//  Created by Iván FV on 08/11/25.
//
// Components/Atoms/StatusChip.swift

import SwiftUI

struct StatusChip: View {
    enum Kind { case pendiente, entregado }

    let kind: Kind

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
            Text(text).font(.subheadline).bold()
        }
        .foregroundStyle(color)
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(
            Capsule().strokeBorder(color.opacity(0.6), lineWidth: 1)
                .background(Capsule().fill(color.opacity(0.08)))
        )
    }

    private var icon: String {
        switch kind {
        case .pendiente: return "clock"
        case .entregado: return "checkmark"
        }
    }
    private var text: String {
        switch kind {
        case .pendiente: return "Pendiente"
        case .entregado: return "Entregado"
        }
    }
    private var color: Color {
        switch kind {
        case .pendiente: return NV.yellow
        case .entregado: return NV.green
        }
    }
}
