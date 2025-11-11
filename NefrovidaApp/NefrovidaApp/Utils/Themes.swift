//
//  Themes.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 10/11/25.
//
// Presentation/Utils/Theme.swift
import SwiftUI

extension Color {
    
//    static let nvLightBlue = Color(red: 0.88, green: 0.95, blue: 1.0)   // fondo tira de semana
//    static let nvBrand     = Color(red: 0.12, green: 0.28, blue: 0.55)  // azul marca
    
    static let nvCardBlue  = Color(red: 0.83, green: 0.91, blue: 1.0)   // card cita
    static let nvBrand     = Color(red: 0.0039, green: 0.0471, blue: 0.3686)  // azul marca #010C5E
    static let nvLightBlue = Color(red: 0.7529, green: 0.9059, blue: 0.9255) // azul claro #C0E7EC
}

extension Font {
    static var nvSmall: Font { .system(size: 12, weight: .regular) }
    static var nvBody:  Font { .system(size: 15, weight: .regular) }
    static var nvSemibold: Font { .system(size: 15, weight: .semibold) }
}

