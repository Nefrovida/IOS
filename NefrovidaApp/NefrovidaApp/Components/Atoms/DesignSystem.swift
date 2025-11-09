//  DesignSystem.swift
//  NefrovidaApp
//
//  Created by Enrique Ayala on 08/11/25.
//
//  Minimal design tokens for colors and spacing.

import SwiftUI

enum ColorPalette {
    // Primary brand colors
    static let primary = Color(red: 0.39, green: 0.87, blue: 0.86) // Turquoise-like
    static let danger = Color(red: 0.83, green: 0.18, blue: 0.18) // ~ #D32F2F
    static let textPrimary = Color(red: 0.10, green: 0.14, blue: 0.49) // ~ #1A237E
    static let textSecondary = Color.gray

    // Containers / Cards
    static let cardPrimary = Color.white // Unify modal/card base to app base (white)

    // Overlays
    static let overlay = Color.black.opacity(0.40)
}

enum Spacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12 // slightly reduced from 16 to fit more content per screen
    static let lg: CGFloat = 20 // slightly reduced
}
