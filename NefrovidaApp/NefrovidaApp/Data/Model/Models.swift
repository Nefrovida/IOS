//
//  Models.swift
//  NefrovidaApp
//
//  Created by Leonardo Cervantes on 08/11/25.
//

import Foundation

// MARK: - Modelos Core

struct Paciente: Codable, Hashable, Identifiable {
  let id: String // patient_id (UUID)
  let nombre: String
  let apellidoPaterno: String
  let apellidoMaterno: String
  let telefono: String
  let avatarURL: String?
  
  var nombreCompleto: String {
    "\(nombre) \(apellidoPaterno) \(apellidoMaterno)"
  }
  
  enum CodingKeys: String, CodingKey {
    case id = "patient_id"
    case nombre = "name"
    case apellidoPaterno = "parent_last_name"
    case apellidoMaterno = "maternal_last_name"
    case telefono = "phone_number"
    case avatarURL = "avatar_url"
  }
}

struct Doctor: Codable, Hashable, Identifiable {
  let id: String // doctor_id (UUID)
  let nombre: String
  let apellidoPaterno: String
  let apellidoMaterno: String?
  let especialidad: String
  let licencia: String
  let telefono: String?
  
  var nombreCompleto: String {
    if let materno = apellidoMaterno {
      return "Dr. \(nombre) \(apellidoPaterno) \(materno)"
    }
    return "Dr. \(nombre) \(apellidoPaterno)"
  }
  
  enum CodingKeys: String, CodingKey {
    case id = "doctor_id"
    case nombre = "name"
    case apellidoPaterno = "parent_last_name"
    case apellidoMaterno = "maternal_last_name"
    case especialidad = "speciality"
    case licencia = "license"
    case telefono = "phone_number"
  }
}

struct SolicitudCita: Codable, Hashable, Identifiable {
  let id: Int // patient_appointment_id
  let patientId: String
  let appointmentId: Int
  let duracion: Int
  let tipoAppointment: String // PRESENCIAL/VIRTUAL
  let status: String
  let paciente: PacienteDetalle
  let appointment: AppointmentDetalle
  
  var tipoConsulta: String {
    appointment.name.trimmingCharacters(in: .whitespaces)
  }
  
  var fechaSolicitud: Date {
    Date() // Las solicitudes son actuales
  }
  
  enum CodingKeys: String, CodingKey {
    case id = "patient_appointment_id"
    case patientId = "patient_id"
    case appointmentId = "appointment_id"
    case duracion = "duration"
    case tipoAppointment = "appointment_type"
    case status = "appointment_status"
    case paciente = "patient"
    case appointment
  }
  
  struct PacienteDetalle: Codable, Hashable {
    let user: UserInfo
  }
  
  struct AppointmentDetalle: Codable, Hashable {
    let appointmentId: Int
    let doctorId: String
    let name: String
    let generalCost: String
    let communityCost: String
    let doctor: DoctorInAppointment
    
    enum CodingKeys: String, CodingKey {
      case appointmentId = "appointment_id"
      case doctorId = "doctor_id"
      case name
      case generalCost = "general_cost"
      case communityCost = "community_cost"
      case doctor
    }
  }
  
  struct DoctorInAppointment: Codable, Hashable {
    let doctorId: String
    let especialidad: String
    let licencia: String
    let user: UserInfo
    
    enum CodingKeys: String, CodingKey {
      case doctorId = "doctor_id"
      case especialidad = "speciality"
      case licencia = "license"
      case user
    }
  }
  
  struct UserInfo: Codable, Hashable {
    let nombre: String
    let apellidoPaterno: String
    let apellidoMaterno: String
    let telefono: String
    
    var nombreCompleto: String {
      "\(nombre) \(apellidoPaterno) \(apellidoMaterno)"
    }
    
    enum CodingKeys: String, CodingKey {
      case nombre = "name"
      case apellidoPaterno = "parent_last_name"
      case apellidoMaterno = "maternal_last_name"
      case telefono = "phone_number"
    }
  }
}

struct DoctorDisponible: Codable, Hashable, Identifiable {
  let id: String // doctor_id
  let userId: String
  let especialidad: String
  let licencia: String
  let user: UserDetalle
  
  var nombreCompleto: String {
    if let materno = user.apellidoMaterno {
      return "Dr. \(user.nombre) \(user.apellidoPaterno) \(materno)"
    }
    return "Dr. \(user.nombre) \(user.apellidoPaterno)"
  }
  
  enum CodingKeys: String, CodingKey {
    case id = "doctor_id"
    case userId = "user_id"
    case especialidad = "speciality"
    case licencia = "license"
    case user
  }
  
  struct UserDetalle: Codable, Hashable {
    let nombre: String
    let apellidoPaterno: String
    let apellidoMaterno: String?
    let telefono: String
    let activo: Bool
    
    var especialidad: String {
      "" // Se obtiene del padre DoctorDisponible
    }
    
    enum CodingKeys: String, CodingKey {
      case nombre = "name"
      case apellidoPaterno = "parent_last_name"
      case apellidoMaterno = "maternal_last_name"
      case telefono = "phone_number"
      case activo = "active"
    }
  }
}

struct SlotDisponibilidad: Codable, Hashable {
  let inicio: Date
  let fin: Date
  let disponible: Bool
  
  var horario: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    formatter.locale = Locale(identifier: "es_ES")
    return formatter.string(from: inicio)
  }
  
  enum CodingKeys: String, CodingKey {
    case inicio = "start"
    case fin = "end"
    case disponible = "available"
  }
}

struct HorarioDisponible: Codable, Hashable {
  let fecha: Date
  let slots: [SlotDisponibilidad]
}

struct CitaProgramada: Codable, Hashable, Identifiable {
  let id: Int // patient_appointment_id
  let patientId: String
  let appointmentId: Int
  let fechaHora: Date
  let duracion: Int
  let tipoAppointment: String
  let link: String?
  let lugar: String?
  let status: String
  
  enum CodingKeys: String, CodingKey {
    case id = "patient_appointment_id"
    case patientId = "patient_id"
    case appointmentId = "appointment_id"
    case fechaHora = "date_hour"
    case duracion = "duration"
    case tipoAppointment = "appointment_type"
    case link
    case lugar = "place"
    case status = "appointment_status"
  }
}

// MARK: - DTOs de Request/Response

struct ProgramarCitaRequest: Codable {
  let patientAppointmentId: Int
  let doctorId: String
  let dateHour: String // ISO 8601
  let duration: Int
  let place: String?
  let link: String?
}

// MARK: - Utilidades

enum NetworkError: Error, LocalizedError, Equatable {
  case badURL
  case decoding
  case server(Int)
  case conflict
  case unknown

  var errorDescription: String? {
    switch self {
    case .badURL:
      return "URL inválida."
    case .decoding:
      return "No se pudo interpretar la respuesta del servidor."
    case .server(let code):
      return "Error del servidor (\(code))."
    case .conflict:
      return "El horario ya no está disponible."
    case .unknown:
      return "Ocurrió un error inesperado."
    }
  }
}

extension JSONDecoder {
  /// JSONDecoder configurado para aceptar formatos de fecha comunes de la API.
  static var nefrovida: JSONDecoder {
    let decoder = JSONDecoder()
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    decoder.dateDecodingStrategy = .custom { decoder in
      let container = try decoder.singleValueContainer()
      let string = try container.decode(String.self)
      // Try ISO8601 with fraction
      if let d1 = formatter.date(from: string) { return d1 }
      // Try ISO8601 without fraction
      let f2 = ISO8601DateFormatter()
      f2.formatOptions = [.withInternetDateTime]
      if let d2 = f2.date(from: string) { return d2 }
      // Try yyyy-MM-dd or yyyy-MM-dd'T'HH:mm
      let patterns = [
        "yyyy-MM-dd'T'HH:mm:ssZ",
        "yyyy-MM-dd'T'HH:mm:ss",
        "yyyy-MM-dd'T'HH:mm",
        "yyyy-MM-dd"
      ]
      let df = DateFormatter()
      df.locale = Locale(identifier: "en_US_POSIX")
      for p in patterns {
        df.dateFormat = p
        if let d = df.date(from: string) { return d }
      }
      throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported date: \(string)")
    }
    return decoder
  }
}

extension JSONEncoder {
  static var nefrovida: JSONEncoder {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    return encoder
  }
}

extension Date {
  var dayLabelEs: String {
    let cal = Calendar.current
    if cal.isDateInToday(self) { return "Hoy" }
    if cal.isDateInTomorrow(self) { return "Mañana" }
    let fmt = DateFormatter()
    fmt.locale = Locale(identifier: "es_ES")
    fmt.dateFormat = "E" // e.g., sáb
    return fmt.string(from: self).capitalized
  }

  func format(_ pattern: String) -> String {
    let df = DateFormatter()
    df.locale = Locale(identifier: "es_ES")
    df.dateFormat = pattern
    return df.string(from: self)
  }
}
