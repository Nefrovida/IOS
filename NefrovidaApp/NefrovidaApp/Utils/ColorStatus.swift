//
//  ColorStatus.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 21/11/25.
//

import SwiftUI

extension Color {
    static func statusColor(for status: String) -> Color {
        switch status.uppercased() {

        // ---- ESTADOS EN INGLÉS ----
        case "FINISHED":
            return .green.opacity(0.7)
        case "PROGRAMMED":
            return .blue.opacity(0.7)
        case "REQUESTED":
            return .yellow.opacity(0.7)
        case "MISSED":
            return .red.opacity(0.7)
        case "CANCELED":
            return .gray.opacity(0.5)

        // ---- ESTADOS EN ESPAÑOL ----
        case "FINALIZADO", "FINALIZADA":
            return .green.opacity(0.7)
        case "PROGRAMADO", "PROGRAMADA":
            return .blue.opacity(0.7)
        case "SOLICITADO", "SOLICITADA", "PEDIDO", "PEDIDA":
            return .yellow.opacity(0.7)
        case "PERDIDO", "PERDIDA":
            return .red.opacity(0.7)
        case "CANCELADO", "CANCELADA":
            return .gray.opacity(0.5)

        default:
            return .nvCardBlue
        }
    }
}
