//
//  AnalysisEntity.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 25/11/25.
//

import Foundation

// Domain-level model used inside the app.
// This is the cleaned and unified version of an analysis,
// independent from how the backend returns data.
struct AnalysisEntity: Identifiable {
    let id: String            // Unique analysis ID (patient_analysis_id)
    let analysisId: Int       // The type/template ID of this analysis
    let date: Date            // Parsed Date object (analysis_date)
    let duration: Int         // Duration of the analysis in minutes
    let status: String        // Current status (e.g., "REQUESTED", "COMPLETED")
    let place: String?        // Location where analysis will be performed
    let patientName: String?  // Optional full patient name
}
