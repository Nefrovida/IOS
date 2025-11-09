//  AnalisisService.swift
//  NefrovidaApp
//
//  Created by Enrique Ayala on 08/11/25.
//
//  Networking layer for Analisis endpoints using async/await and URLSession.

import Foundation

/// Abstraction for the Analisis service to allow dependency injection and testing.
protocol AnalisisServiceProtocol {
    /// Fetches the list of analyses from backend.
    func fetchAnalisis() async throws -> [Analisis]

    /// Deletes an analysis with the given identifier.
    /// - Parameter id: Unique analysis identifier.
    func deleteAnalisis(id: String) async throws
}

/// Concrete implementation of `AnalisisServiceProtocol` using `URLSession`.
struct AnalisisService: AnalisisServiceProtocol {
    // MARK: - Configuration

    /// Base URL for the backend API. Adjust as needed or inject via initializer.
    private let baseURL: URL

    /// Custom JSON decoder configured for common backend formats.
    private let decoder: JSONDecoder

    /// Custom JSON encoder if needed for requests.
    private let encoder: JSONEncoder

    // MARK: - Init

    init(baseURL: URL = URL(string: "https://api.nefrovida.mx")!) {
        self.baseURL = baseURL

        let decoder = JSONDecoder()
        // Use ISO8601 by default; override if your backend uses a different format.
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        self.encoder = encoder
    }

    // MARK: - Endpoints

    func fetchAnalisis() async throws -> [Analisis] {
        let endpoint = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("analisis")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await URLSession.shared.data(for: request)
        try Self.validateHTTP(response: response)
        return try decoder.decode([Analisis].self, from: data)
    }

    func deleteAnalisis(id: String) async throws {
        let endpoint = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("analisis")
            .appendingPathComponent(id)
        var request = URLRequest(url: endpoint)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (_, response) = try await URLSession.shared.data(for: request)
        try Self.validateHTTP(response: response)
    }

    // MARK: - Helpers

    /// Validates the HTTP response, throwing detailed errors for non-2xx status codes.
    private static func validateHTTP(response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        switch http.statusCode {
        case 200 ..< 300:
            return
        case 400:
            throw NetworkError.badRequest
        case 401:
            throw NetworkError.unauthorized
        case 403:
            throw NetworkError.forbidden
        case 404:
            throw NetworkError.notFound
        case 500 ..< 600:
            throw NetworkError.serverError(status: http.statusCode)
        default:
            throw NetworkError.unexpectedStatus(status: http.statusCode)
        }
    }
}

// MARK: - Network Errors

/// Network layer error types.
enum NetworkError: LocalizedError, Equatable {
    case invalidResponse
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case serverError(status: Int)
    case unexpectedStatus(status: Int)

    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return NSLocalizedString("error_invalid_response", comment: "Invalid response")
        case .badRequest:
            return NSLocalizedString("error_bad_request", comment: "Bad request")
        case .unauthorized:
            return NSLocalizedString("error_unauthorized", comment: "Unauthorized")
        case .forbidden:
            return NSLocalizedString("error_forbidden", comment: "Forbidden")
        case .notFound:
            return NSLocalizedString("error_not_found", comment: "Not found")
        case let .serverError(status):
            return String(format: NSLocalizedString("error_server", comment: "Server error"), status)
        case let .unexpectedStatus(status):
            return String(format: NSLocalizedString("error_unexpected_status", comment: "Unexpected status"), status)
        }
    }
}
