//
//  NetworkService.swift
//  NefrovidaApp
//
//  Created by Leonardo Cervantes on 08/11/25.
//

import Foundation

protocol NetworkServicing {
  func fetchSolicitudes() async throws -> [SolicitudCita]
  func fetchDoctores() async throws -> [DoctorDisponible]
  func fetchDisponibilidad(doctorId: String, fecha: Date) async throws -> [SlotDisponibilidad]
  func programarCita(request: ProgramarCitaRequest) async throws -> CitaProgramada
}

final class NetworkService: NetworkServicing {
  private let baseURL: URL
  private let session: URLSession

  init(baseURL: URL = URL(string: "http://localhost:3001")!, session: URLSession = .shared) {
    self.baseURL = baseURL
    self.session = session
  }

  // MARK: - API Pública

  func fetchSolicitudes() async throws -> [SolicitudCita] {
    let endpoint = baseURL.appendingPathComponent("api/secretary-agenda/appointment-requests")
    let (data, response) = try await session.data(from: endpoint)
    try validate(response: response)
    do {
      return try JSONDecoder.nefrovida.decode([SolicitudCita].self, from: data)
    } catch {
      print("Error de decodificación: \(error)")
      throw NetworkError.decoding
    }
  }
  
  func fetchDoctores() async throws -> [DoctorDisponible] {
    let endpoint = baseURL.appendingPathComponent("api/secretary-agenda/doctors")
    let (data, response) = try await session.data(from: endpoint)
    try validate(response: response)
    do {
      return try JSONDecoder.nefrovida.decode([DoctorDisponible].self, from: data)
    } catch {
      print("Error de decodificación: \(error)")
      throw NetworkError.decoding
    }
  }

  func fetchDisponibilidad(doctorId: String, fecha: Date) async throws -> [SlotDisponibilidad] {
    let dateString = fecha.format("yyyy-MM-dd")
    guard var components = URLComponents(
      url: baseURL.appendingPathComponent("api/secretary-agenda/doctor/\(doctorId)/availability"),
      resolvingAgainstBaseURL: false
    ) else {
      throw NetworkError.badURL
    }
    components.queryItems = [URLQueryItem(name: "date", value: dateString)]
    guard let url = components.url else { throw NetworkError.badURL }
    let (data, response) = try await session.data(from: url)
    try validate(response: response)
    do {
      return try JSONDecoder.nefrovida.decode([SlotDisponibilidad].self, from: data)
    } catch {
      print("Error de decodificación: \(error)")
      throw NetworkError.decoding
    }
  }

  func programarCita(request: ProgramarCitaRequest) async throws -> CitaProgramada {
    let url = baseURL.appendingPathComponent("api/secretary-agenda/schedule")
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "POST"
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    urlRequest.httpBody = try JSONEncoder.nefrovida.encode(request)
    let (data, response) = try await session.data(for: urlRequest)
    do {
      try validate(response: response)
    } catch NetworkError.server(let code) where code == 409 {
      throw NetworkError.conflict
    }
    catch { throw error }
    do {
      return try JSONDecoder.nefrovida.decode(CitaProgramada.self, from: data)
    } catch {
      print("Error de decodificación: \(error)")
      throw NetworkError.decoding
    }
  }

  // MARK: - Validación

  private func validate(response: URLResponse) throws {
    guard let http = response as? HTTPURLResponse else { throw NetworkError.unknown }
    switch http.statusCode {
    case 200...299: return
    case 409: throw NetworkError.server(409)
    default: throw NetworkError.server(http.statusCode)
    }
  }
}

// MARK: - Servicio Mock para Pruebas

final class MockNetworkService: NetworkServicing {
  var solicitudes: [SolicitudCita] = []
  var doctores: [DoctorDisponible] = []
  var disponibilidad: [SlotDisponibilidad] = []
  var shouldThrowConflict: Bool = false
  
  func fetchSolicitudes() async throws -> [SolicitudCita] {
    solicitudes
  }
  
  func fetchDoctores() async throws -> [DoctorDisponible] {
    doctores
  }
  
  func fetchDisponibilidad(doctorId: String, fecha: Date) async throws -> [SlotDisponibilidad] {
    disponibilidad
  }
  
  func programarCita(request: ProgramarCitaRequest) async throws -> CitaProgramada {
    if shouldThrowConflict {
      throw NetworkError.conflict
    }
    CitaProgramada(
      id: request.patientAppointmentId,
      patientId: "test-patient",
      appointmentId: 1,
      fechaHora: Date(),
      duracion: request.duration,
      tipoAppointment: "PRESENCIAL",
      link: request.link,
      lugar: request.place,
      status: "SCHEDULED"
    )
  }
}
