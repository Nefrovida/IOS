//
//  AppointmentEntity.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 16/11/25.
//

import Foundation

// Domain-level model used inside the app.
// This is the cleaned and unified version of an appointment,
// independent from how the backend returns data.
//
// Conforms to Identifiable so it can be used directly in SwiftUI lists.
struct AppointmentEntity: Identifiable {
    
    let id: Int               // Unique appointment ID (for SwiftUI and internal logic)
    let appointmentId: Int    // The type/template ID of this appointment
    let date: Date            // Parsed Date object (converted from backend string)
    let duration: Int         // Duration of the appointment in minutes
    let status: String        // Current status (e.g., "pending", "completed")
    let patientName: String?  // Optional full patient name (built from components)
}
