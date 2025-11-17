//
//  AppointmentModel.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 16/11/25.
//

import Foundation

struct AppointmentModel: Decodable {
    let patient_appointment_id: Int
    let patient_id: String?
    let appointment_id: Int
    let date_hour: String
    let duration: Int
    let appointment_type: String?
    let link: String?
    let place: String?
    let appointment_status: String
    let patient_name: String?
    let patient_parent_last_name: String?
    let patient_maternal_last_name: String?
}

struct CreateAppointmentResponse: Decodable {
    let success: Bool
    let appointment: AppointmentModel
}

extension AppointmentModel {
    func toEntity() -> AppointmentEntity {
        AppointmentEntity(
            id: patient_appointment_id,
            appointmentId: appointment_id,
            date: parseDate(from: date_hour),
            duration: duration,
            status: appointment_status,
            patientName: buildPatientName()
        )
    }
    
    private func parseDate(from string: String) -> Date {

        let iso8601Formatter = ISO8601DateFormatter()
        iso8601Formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = iso8601Formatter.date(from: string) {
            return date
        }
        
        iso8601Formatter.formatOptions = [.withInternetDateTime]
        if let date = iso8601Formatter.date(from: string) {
            return date
        }
        
        let customFormatter = DateFormatter()
        customFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        customFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = customFormatter.date(from: string) {
            return date
        }
        
        customFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = customFormatter.date(from: string) {
            return date
        }
        return Date()
    }

    private func buildPatientName() -> String? {
        let components = [patient_name, patient_parent_last_name, patient_maternal_last_name]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
        
        return components.isEmpty ? nil : components.joined(separator: " ")
    }
}
