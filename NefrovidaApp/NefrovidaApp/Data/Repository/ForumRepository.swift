//
//  ForumRepository.swift
//  NefrovidaApp
//
//  Created by Armando Fuentes Silva on 17/11/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case unauthorized
    case serverError(String)
    case decodingError
    case unknown
}

class ForumRepository {
    private let baseURL = "http://localhost:3001"
    private var authToken: String?
    
    // MARK: - Configuración para testing
    // Cambiar a false para usar autenticación
    private let bypassAuth = true
    
    func setAuthToken(_ token: String) {
        self.authToken = token
    }
    
    // MARK: - Get Messages Feed
    func getMessagesFeed(page: Int = 1, limit: Int = 20) async throws -> MessagesFeedResponse {
        guard let url = URL(string: "\(baseURL)/forums/feed?page=\(page)&limit=\(limit)") else {
            throw NetworkError.invalidURL
        }
        
        // Solo verificar token si no estamos en modo bypass
        if !bypassAuth {
            guard let token = authToken else {
                throw NetworkError.unauthorized
            }
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Solo agregar header de autorización si tenemos token
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let feedResponse = try decoder.decode(MessagesFeedResponse.self, from: data)
                return feedResponse
            } catch {
                print("Decoding error: \(error)")
                print("Response data: \(String(data: data, encoding: .utf8) ?? "Unable to decode")")
                throw NetworkError.decodingError
            }
        case 401, 403:
            if bypassAuth {
                print("Warning: Received 401/403 but bypassAuth is enabled. Check if backend requires auth.")
            }
            throw NetworkError.unauthorized
        default:
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            print("Error response: \(errorMessage)")
            throw NetworkError.unknown
        }
    }
    
    // MARK: - Send Message to Forum
    func sendMessage(forumId: Int, content: String) async throws -> MessageResponse {
        guard let url = URL(string: "\(baseURL)/forums/\(forumId)") else {
            throw NetworkError.invalidURL
        }
        
        // Solo verificar token si no estamos en modo bypass
        if !bypassAuth {
            guard let token = authToken else {
                throw NetworkError.unauthorized
            }
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Solo agregar header de autorización si tenemos token
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let body = CreateMessageRequest(message: content)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            do {
                let messageResponse = try JSONDecoder().decode(MessageResponse.self, from: data)
                return messageResponse
            } catch {
                print("Decoding error: \(error)")
                print("Response data: \(String(data: data, encoding: .utf8) ?? "Unable to decode")")
                throw NetworkError.decodingError
            }
        case 401, 403:
            if bypassAuth {
                print("Warning: Received 401/403 but bypassAuth is enabled. Check if backend requires auth.")
            }
            throw NetworkError.unauthorized
        case 500...599:
            let errorMessage = String(data: data, encoding: .utf8) ?? "Server error"
            print("Server error: \(errorMessage)")
            throw NetworkError.serverError(errorMessage)
        default:
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            print("Error response: \(errorMessage)")
            throw NetworkError.unknown
        }
    }
}
