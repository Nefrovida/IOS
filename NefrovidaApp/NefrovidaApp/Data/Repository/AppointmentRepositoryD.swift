//
//  AppointmentModel.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 16/11/25.
//

import Foundation

final class AppointmentRepositoryD: appointmentRepository {

    private let base = "http://localhost:3001/api/agenda"

    func getAppointments(for date: Date, appointmentId: Int) async throws -> [AppointmentEntity] {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        let dateFormatted = formatter.string(from: date)

        guard let url = URL(string: "\(base)/appointments-per-day/by-appointment?date=\(dateFormatted)&appointmentId=\(appointmentId)") else {
            throw URLError(.badURL)
        }

        print("📡 GET Request: \(url.absoluteString)")

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📊 Status Code: \(httpResponse.statusCode)")
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📦 Response JSON: \(jsonString)")
            }
            
            let decoded = try JSONDecoder().decode([AppointmentModel].self, from: data)
            print("✅ Decoded \(decoded.count) appointments")
            
            return decoded.map { $0.toEntity() }
            
        } catch let decodingError as DecodingError {
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
            print("❌ Network Error: \(error.localizedDescription)")
            throw error
        }
    }

    func createAppointment(
        userId: String,
        appointmentId: Int,
        dateHour: Date
    ) async throws -> AppointmentEntity {

        guard let url = URL(string: "\(base)/appointment") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Convertir la fecha local a UTC antes de enviar
        // La fecha 'dateHour' ya está en hora local (ej: 09:00 -0600)
        // ISO8601DateFormatter automáticamente la convierte a UTC al serializar
        let iso8601Formatter = ISO8601DateFormatter()
        iso8601Formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        iso8601Formatter.timeZone = TimeZone(identifier: "UTC")
        
        let dateString = iso8601Formatter.string(from: dateHour)

        let body: [String: Any] = [
            "user_id": userId,
            "appointment_id": appointmentId,
            "date_hour": dateString
        ]

        print("📡 POST Request: \(url.absoluteString)")
        print("📦 Body: \(body)")
        print("📅 Fecha local: \(dateHour)")
        print("📅 Fecha UTC enviada: \(dateString)")

        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📊 Status Code: \(httpResponse.statusCode)")
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📦 Response JSON: \(jsonString)")
            }
            
            let decoded = try JSONDecoder().decode(CreateAppointmentResponse.self, from: data)
            print("✅ Appointment created successfully")
            
            return decoded.appointment.toEntity()
            
        } catch {
            print("❌ Error creating appointment: \(error.localizedDescription)")
            throw error
        }
    }
}
