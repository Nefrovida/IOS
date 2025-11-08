//
//  CalendarRepository.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 08/11/25.
//

// Data/Repository/RemoteAppointmentRepository.swift
import Foundation

public final class RemoteAppointmentRepository: AppointmentRepository {
    private let baseURL: String
    public init(baseURL: String) { self.baseURL = baseURL }

    public func fetchAppointments(forDate date: String) async throws -> [Appointment] {
        guard var comps = URLComponents(string: "\(baseURL)/appointments") else {
            throw URLError(.badURL)
        }
        comps.queryItems = [URLQueryItem(name: "date", value: date)]
        guard let url = comps.url else { throw URLError(.badURL) }

        let (data, response) = try await URLSession.shared.data(from: url)
        if let http = response as? HTTPURLResponse, http.statusCode >= 400 {
            throw URLError(.badServerResponse)
        }
        let list = try JSONDecoder().decode([AppointmentDTO].self, from: data)
        return list.map { $0.toDomain() }
    }
}
