//
//  AppointmentModel.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 16/11/25.
//

import Foundation

// Represents an appointment received from the backend.
// This structure mirrors the JSON response exactly.
struct AppointmentModel: Decodable {
    let patient_appointment_id: Int          // Unique ID for the patient's appointment
    let patient_id: String?                  // ID of the patient (optional)
    let appointment_id: Int                 // ID of the appointment template/type
    let date_hour: String                   // Date/time in string format from backend
    let duration: Int                       // Duration of the appointment (in minutes)
    let appointment_type: String?           // Type of appointment (optional)
    let link: String?                       // Link for online appointments (optional)
    let place: String?                      // Physical location (optional)
    let appointment_status: String          // Status (e.g., pending, completed)
    let patient_name: String?               // First name of the patient
    let patient_parent_last_name: String?   // Father's last name (optional)
    let patient_maternal_last_name: String? // Mother's last name (optional)
}

// Represents the response after creating an appointment.
struct CreateAppointmentResponse: Decodable {
    let success: Bool                       // Whether the request succeeded
    let appointment: AppointmentModel       // The created appointment returned by the backend
}

extension AppointmentModel {
    // Converts the network model into a domain-level entity used inside the app.
    func toEntity() -> AppointmentEntity {
        AppointmentEntity(
            id: patient_appointment_id,
            appointmentId: appointment_id,
            date: parseDate(from: date_hour),    // Convert string to Date
            duration: duration,
            status: appointment_status,
            patientName: buildPatientName()      // Build full name safely
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

    // Builds a full patient name by combining available components.
    // Removes nils and empty strings.
    private func buildPatientName() -> String? {
        let components = [
            patient_name,
            patient_parent_last_name,
            patient_maternal_last_name
        ]
        .compactMap { $0 }           // Remove nil values
        .filter { !$0.isEmpty }      // Remove empty strings
        
        return components.isEmpty ? nil : components.joined(separator: " ")
    }
}
