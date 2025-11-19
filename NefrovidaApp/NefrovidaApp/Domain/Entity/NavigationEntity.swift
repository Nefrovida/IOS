//
//  NavigationEntity.swift
//  NefrovidaApp
//
//  Created by Leonardo Cervantes on 17/11/25.
//

import Foundation

// Navigation tab entity for main app navigation
enum Tab: Equatable {
    case inicio
    case analisis
    case foros
    case agenda
    
    var iconName: String {
        switch self {
        case .inicio: return "house"
        case .analisis: return "testtube.2"
        case .foros: return "text.bubble"
        case .agenda: return "calendar"
        }
    }
    
    var label: String {
        switch self {
        case .inicio: return "Inicio"
        case .analisis: return "Análisis"
        case .foros: return "Foros"
        case .agenda: return "Agenda"
        }
    }
}
