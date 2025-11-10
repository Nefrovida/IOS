//
//  Theme.swift
//  NefrovidaApp
//
//  Created by Leonardo Cervantes on 08/11/25.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

enum Theme {
  // Colores primarios del diseño
  static let turquoisePrimary = Color(hex: "#4DD0E1") // Turquesa claro - botones primarios
  static let turquoiseLight = Color(hex: "#B2EBF2") // Turquesa muy claro - backgrounds
  static let redDelete = Color(hex: "#D32F2F") // Rojo - botón eliminar
  static let blueDark = Color(hex: "#1A237E") // Azul oscuro - textos principales
  static let graySecondary = Color(hex: "#757575") // Gris - textos secundarios
  static let whitePrimary = Color.white // Blanco - fondo principal
  
  // Alias heredados para compatibilidad (se actualizarán las vistas gradualmente)
  static let primaryBlue = turquoisePrimary
  static let modalBackground = turquoiseLight.opacity(0.3)
  static let activeBlue = turquoiseLight
  static let titleBlue = blueDark

  #if os(iOS)
  static let cardBackground = Color(UIColor.systemBackground)
  static let secondaryBackground = Color(UIColor.secondarySystemBackground)
  #elseif os(macOS)
  static let cardBackground = Color(NSColor.windowBackgroundColor)
  static let secondaryBackground = Color(NSColor.controlBackgroundColor)
  #else
  static let cardBackground = Color.white
  static let secondaryBackground = Color.gray.opacity(0.15)
  #endif
}

struct CardModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .padding()
      .background(Theme.cardBackground)
      .cornerRadius(12)
      .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
  }
}

extension View {
  func cardStyle() -> some View { modifier(CardModifier()) }
}
