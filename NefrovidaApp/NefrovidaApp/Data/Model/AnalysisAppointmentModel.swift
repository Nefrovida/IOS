//
//  AnalysisAppointmentModel.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 25/11/25.
//

import Foundation

// Represents an analysis received from the backend.
// This structure mirrors the JSON response exactly.
struct AnalysisModel: Decodable {
    let patient_analysis_id: String         // Unique ID for the patient's analysis
    let patient_id: String?                 // ID of the patient (optional)
    let analysis_id: Int                    // ID of the analysis type
    let laboratorist_id: String?            // ID of assigned laboratorist (optional)
    let analysis_date: String               // Date/time in string format from backend
    let results_date: String?               // Date when results are ready (optional)
    let place: String?                      // Physical location (optional)
    let duration: Int                       // Duration of the analysis (in minutes)
    let analysis_status: String             // Status (e.g., REQUESTED, PROGRAMMED, COMPLETED)
    let patient_name: String?               // Name of the patient
}

// Represents the response after creating an analysis.
struct CreateAnalysisResponse: Decodable {
    let success: Bool                       // Whether the request succeeded
    let analysis: AnalysisModel             // The created analysis returned by the backend
}

extension AnalysisModel {
    // Converts the network model into a domain-level entity used inside the app.
    func toEntity() -> AnalysisEntity {
        AnalysisEntity(
            id: patient_analysis_id,
            analysisId: analysis_id,
            date: parseDate(from: analysis_date),
            duration: duration,
            status: analysis_status,
            place: place,
            patientName: patient_name
        )
    }
    
    // Attempts to parse multiple date formats to ensure backend compatibility.
    private func parseDate(from string: String) -> Date {
        // Try ISO8601 format with fractional seconds (e.g., "2024-06-10T14:30:15.123Z")
        let iso8601Formatter = ISO8601DateFormatter()
        iso8601Formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = iso8601Formatter.date(from: string) {
            return date
        }
        
        // Try ISO8601 format without fractional seconds (e.g., "2024-06-10T14:30:15Z")
        iso8601Formatter.formatOptions = [.withInternetDateTime]
        if let date = iso8601Formatter.date(from: string) {
            return date
        }
        
        // Try custom format: "yyyy-MM-dd'T'HH:mm:ss"
        let customFormatter = DateFormatter()
        customFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        customFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = customFormatter.date(from: string) {
            return date
        }
        
        // Try custom format without the "T": "yyyy-MM-dd HH:mm:ss"
        customFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = customFormatter.date(from: string) {
            return date
        }
        
        // If everything fails, return current date (fallback)
        return Date()
    }
}
