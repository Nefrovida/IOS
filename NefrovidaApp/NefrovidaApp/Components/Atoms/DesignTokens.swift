//
//  DesignTokens.swift
//  NefrovidaApp
//
//  Created by Iván FV on 08/11/25.
//

import SwiftUI

enum NV {
    static let blue = Color(red: 0.04, green: 0.14, blue: 0.38)     // Textos
    static let yellow = Color(red: 0.98, green: 0.80, blue: 0.16)   // Pendiente
    static let green = Color(red: 0.23, green: 0.64, blue: 0.33)    // Entregado
    static let cardBG = Color(.systemBackground)
    static let pageBG = Color(.systemGroupedBackground)

    // Sombras
    static func elevation(_ level: Int) -> ShadowStyle {
        switch level {
        case 1: return ShadowStyle(color: .black.opacity(0.08), radius: 8, y: 3)
        case 2: return ShadowStyle(color: .black.opacity(0.12), radius: 12, y: 6)
        default: return ShadowStyle(color: .black.opacity(0.06), radius: 4, y: 1)
        }
    }

    struct ShadowStyle {
        let color: Color
        let radius: CGFloat
        let y: CGFloat
    }
}

extension View {
    func nvShadow(_ s: NV.ShadowStyle) -> some View {
        shadow(color: s.color, radius: s.radius, x: 0, y: s.y)
    }
}
