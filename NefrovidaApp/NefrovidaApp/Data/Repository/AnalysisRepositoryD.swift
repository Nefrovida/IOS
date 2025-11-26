//
//  AnalysisRepositoryD.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 25/11/25.
//

import Foundation

// Repository that handles analysis API calls.
// Implements the 'AnalysisRepository' protocol.
final class AnalysisRepositoryD: AnalysisRepository {
    
    // Fetch all analysis for a specific date and analysis type
    func getAnalysis(for date: Date, analysisId: Int) async throws -> [AnalysisEntity] {
        
        // Format the date to "yyyy-MM-dd" because the API expects that format
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        let dateFormatted = formatter.string(from: date)
        
        // Build the URL for the GET request
        guard let url = URL(string: "\(AppConfig.apiBaseURL)/analysis/analysis-per-day/by-analysis?date=\(dateFormatted)&analysisId=\(analysisId)") else {
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
            
            // Decode the JSON array into AnalysisModel objects
            let decoded = try JSONDecoder().decode([AnalysisModel].self, from: data)
            print("✅ Decoded \(decoded.count) analysis")
            
            // Convert network models to domain entities
            return decoded.map { $0.toEntity() }
            
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
    
    // Creates a new analysis in the backend
    func createAnalysis(
        userId: String,
        analysisId: Int,
        analysisDate: Date,
        place: String?
    ) async throws -> AnalysisEntity {
        
        // Build POST request URL
        guard let url = URL(string: "\(AppConfig.apiBaseURL)/analysis/analysis-appointment") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Convert the local date to UTC using ISO8601 format
        let iso8601Formatter = ISO8601DateFormatter()
        iso8601Formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        iso8601Formatter.timeZone = TimeZone(identifier: "UTC")
        
        let dateString = iso8601Formatter.string(from: analysisDate)
        
        // JSON body for the POST request
        var body: [String: Any] = [
            "user_id": userId,
            "analysis_id": analysisId,
            "analysis_date": dateString
        ]
        
        // Add place if provided
        if let place = place {
            body["place"] = place
        }
        
        print("📡 POST Request: \(url.absoluteString)")
        print("📦 Body: \(body)")
        print("📅 Local Date: \(analysisDate)")
        print("📅 UTC Date sent: \(dateString)")
        
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
            
            // Decode the response (success + analysis)
            let decoded = try JSONDecoder().decode(CreateAnalysisResponse.self, from: data)
            print("✅ Analysis created successfully")
            
            // Convert to domain entity
            return decoded.analysis.toEntity()
            
        } catch {
            print("❌ Error creating analysis: \(error.localizedDescription)")
            throw error
        }
    }
}
