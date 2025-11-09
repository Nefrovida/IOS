//  Analisis.swift
//  NefrovidaApp
//
//  Created by Enrique Ayala on 08/11/25.
//
//  Model representing a medical analysis entity.
//  Follows Google Swift Style Guide naming and documentation conventions.

import Foundation

/// Domain model for a medical analysis.
/// Conforms to `Identifiable` and `Codable` for SwiftUI lists and network layer encoding/decoding.
struct Analisis: Identifiable, Codable, Equatable { // Equatable aids in diffing & tests
    /// Unique identifier provided by backend.
    let id: String
    /// Title or short name of the analysis.
    let titulo: String
    /// Date the analysis was performed or registered.
    let fecha: Date
    /// Type/category e.g., "Laboratorio", "Imagen".
    let tipo: String

    /// Returns a formatted date string in DD-MM-YYYY format.
    var fechaCorta: String {
        DateFormatter.analisisDisplayFormatter.string(from: fecha)
    }
}

// MARK: - DateFormatter Helpers
extension DateFormatter {
    /// Shared date formatter for displaying analysis dates.
    static let analisisDisplayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()

    /// Formatter matching ISO-8601 backend date strings if needed for manual parsing.
    static let backendISOFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
}
