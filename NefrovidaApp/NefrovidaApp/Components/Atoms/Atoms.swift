//
//  Atoms.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 28/10/25.
//

import SwiftUI

// MARK: - Color Atoms
extension Color {
  init(hex: String) {
    var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    hexString = hexString.replacingOccurrences(of: "#", with: "")
    var rgb: UInt64 = 0
    Scanner(string: hexString).scanHexInt64(&rgb)
    let r = Double((rgb & 0xFF0000) >> 16) / 255.0
    let g = Double((rgb & 0x00FF00) >> 8) / 255.0
    let b = Double(rgb & 0x0000FF) / 255.0
    self = Color(red: r, green: g, blue: b)
  }
}

// MARK: - Typography Atoms
enum AppTypography {
  static let headline = Font.headline
  static let subheadline = Font.subheadline
  static let body = Font.body
  static let caption = Font.caption
  static let largeTitle = Font.largeTitle
}

// MARK: - Spacing Atoms
enum AppSpacing {
  static let xs: CGFloat = 4
  static let sm: CGFloat = 8
  static let md: CGFloat = 12
  static let lg: CGFloat = 16
  static let xl: CGFloat = 24
  static let xxl: CGFloat = 32
}

// MARK: - Corner Radius Atoms
enum AppCornerRadius {
  static let sm: CGFloat = 8
  static let md: CGFloat = 12
  static let lg: CGFloat = 16
  static let xl: CGFloat = 24
}
