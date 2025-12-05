//
//  AppointmentModel.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 16/11/25.
//

import Foundation

// Repository that handles appointment API calls.
// Implements the 'appointmentRepository' protocol.
final class AppointmentRepositoryD: appointmentRepository {

    // Fetch all appointments for a specific date and appointment type
    func getAppointments(for date: Date, appointmentId: Int) async throws -> [AppointmentEntity] {

        // Format the date to "yyyy-MM-dd" because the API expects that format
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        let dateFormatted = formatter.string(from: date)

        // Build the URL for the GET request
        guard let url = URL(string: "\(AppConfig.apiBaseURL)/agenda/appointments-per-day/by-appointment?date=\(dateFormatted)&appointmentId=\(appointmentId)") else {
            throw URLError(.badURL)
        }

        print("📡 GET Request: \(url.absoluteString)")

        do {
            // Perform the HTTP GET request
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Print the HTTP status code if available
            if let httpResponse = response as? HTTPURLResponse {
                print("📊 Status Code: \(httpResponse.statusCode)")
            }
            
            // Print the raw JSON response for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📦 Response JSON: \(jsonString)")
            }
            
            // Decode the JSON array into AppointmentModel objects
            let decoded = try JSONDecoder().decode([AppointmentModel].self, from: data)
            print("✅ Decoded \(decoded.count) appointments")
            
            // ADJUST: Add 6 hours to each date received from the backend
            let adjustedAppointments = decoded.compactMap { model -> AppointmentEntity? in
                let entity = model.toEntity()
                
                // Add 6 hours to compensate for the time zone difference.
                guard let adjustedDate = Calendar.current.date(byAdding: .hour, value: 6, to: entity.date) else {
                    return entity
                }
                
                print("📅 Adjusted date: \(entity.date) -> \(adjustedDate)")
                
                return AppointmentEntity(
                    id: entity.id,
                    appointmentId: entity.appointmentId,
                    date: adjustedDate,
                    duration: entity.duration,
                    status: entity.status,
                    patientName: entity.patientName
                )
            }
            
            return adjustedAppointments
            
        } catch let decodingError as DecodingError {
            // Detailed decoding error inspection
            print("❌ Decoding Error: \(decodingError)")
            
            switch decodingError {
            case .dataCorrupted(let context):
                print("   Context: \(context)")
            case .keyNotFound(let key, let context):
                print("   Key '\(key.stringValue)' not found: \(context.debugDescription)")
            case .typeMismatch(let type, let context):
                print("   Type '\(type)' mismatch: \(context.debugDescription)")
            case .valueNotFound(let type, let context):
                print("   Value '\(type)' not found: \(context.debugDescription)")
            @unknown default:
                print("   Unknown decoding error")
            }
            
            throw decodingError
        } catch {
            // General networking or unknown error
            print("❌ Network Error: \(error.localizedDescription)")
            throw error
        }
    }

    // Creates a new appointment in the backend
    func createAppointment(
        userId: String,
        appointmentId: Int,
        dateHour: Date
    ) async throws -> AppointmentEntity {

        // Build POST request URL
        guard let url = URL(string: "\(AppConfig.apiBaseURL)/agenda/appointment") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")


        guard let adjustedDate = Calendar.current.date(byAdding: .hour, value: -6, to: dateHour) else {
            throw URLError(.badURL)
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0) ?? TimeZone(identifier: "GMT")!
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let dateString = formatter.string(from: adjustedDate)

        // JSON body for the POST request
        let body: [String: Any] = [
            "user_id": userId,
            "appointment_id": appointmentId,
            "date_hour": dateString
        ]

        print("📡 POST Request: \(url.absoluteString)")
        print("📦 Body: \(body)")
        print("📅 User selected: \(dateHour)")
        print("📅 Adjusted (-6h): \(adjustedDate)")
        print("📅 Date sent to backend: \(dateString)")
        print("📅 Expected to be saved in DB: \(dateHour)")

        // Convert body dictionary to JSON data
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

        do {
            // Perform the HTTP POST request
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Print the HTTP status code if available
            if let httpResponse = response as? HTTPURLResponse {
                print("📊 Status Code: \(httpResponse.statusCode)")
            }
            
            // Print raw JSON response for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📦 Response JSON: \(jsonString)")
            }
            
            // Decode the response (success + appointment)
            let decoded = try JSONDecoder().decode(CreateAppointmentResponse.self, from: data)
            print("✅ Appointment created successfully")
            
            // Convert to domain entity
            return decoded.appointment.toEntity()
            
        } catch {
            print("❌ Error creating appointment: \(error.localizedDescription)")
            throw error
        }
    }
}
