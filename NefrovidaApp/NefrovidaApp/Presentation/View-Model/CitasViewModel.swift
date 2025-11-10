//
//  CitasViewModel.swift
//  NefrovidaApp
//
//  Created by Leonardo Cervantes on 08/11/25.
//

import Foundation
import SwiftUI
import Combine

final class CitasViewModel: ObservableObject {
  // MARK: - Tipos Anidados

  enum ScreenState: Equatable {
    case idle
    case loading
    case mostrandoSolicitudes
    case seleccionandoDoctorHorario
    case error(String)
  }

  // MARK: - Propiedades Publicadas

  @Published private(set) var solicitudes: [SolicitudCita] = []
  @Published private(set) var doctores: [DoctorDisponible] = []
  @Published private(set) var slotsDisponibles: [SlotDisponibilidad] = []
  @Published private(set) var selectedSolicitud: SolicitudCita?
  @Published var selectedDoctor: DoctorDisponible?
  @Published var selectedSlot: SlotDisponibilidad?
  @Published var selectedDate: Date = Date()
  @Published private(set) var state: ScreenState = .idle
  @Published var searchQuery: String = ""
  @Published var showSuccessAlert: Bool = false
  @Published var scheduledAppointmentId: Int?

  // MARK: - Dependencias

  private let service: NetworkServicing
  private let dateProvider: () -> Date

  // MARK: - Inicialización

  init(service: NetworkServicing = NetworkService(), dateProvider: @escaping () -> Date = Date.init) {
    self.service = service
    self.dateProvider = dateProvider
  }

  // MARK: - Métodos de Intención

  func onAgendarCitaScreenLoaded() {
    Task { await cargarSolicitudes() }
  }

  func onSolicitudSeleccionada(idSolicitud: Int) {
    guard let solicitud = solicitudes.first(where: { $0.id == idSolicitud }) else { return }
    selectedSolicitud = solicitud
    state = .seleccionandoDoctorHorario
    Task { await cargarDoctores() }
  }
  
  func onDoctorSeleccionado(doctorId: String) {
    selectedDoctor = doctores.first(where: { $0.id == doctorId })
    Task { await cargarDisponibilidad() }
  }
  
  func onDateChanged(_ newDate: Date) {
    selectedDate = newDate
    selectedSlot = nil
    if selectedDoctor != nil {
      Task { await cargarDisponibilidad() }
    }
  }

  func onProgramarCita() async {
    guard let solicitud = selectedSolicitud,
          let doctor = selectedDoctor,
          let slot = selectedSlot else { return }
    state = .loading
    do {
      let formatter = ISO8601DateFormatter()
      formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
      let request = ProgramarCitaRequest(
        patientAppointmentId: solicitud.id,
        doctorId: doctor.id,
        dateHour: formatter.string(from: slot.inicio),
        duration: solicitud.duracion,
        place: solicitud.tipoAppointment == "PRESENCIAL" ? "Consultorio principal" : nil,
        link: solicitud.tipoAppointment == "VIRTUAL" ? "https://meet.nefrovida.com" : nil
      )
      let cita = try await service.programarCita(request: request)
      scheduledAppointmentId = cita.id
      showSuccessAlert = true
      state = .mostrandoSolicitudes
      // Refresh requests list
      await cargarSolicitudes()
    } catch let error as NetworkError {
      state = .error(error.errorDescription ?? "Error desconocido")
    } catch {
      state = .error("Error desconocido")
    }
  }

  func resetAfterConfirmation() {
    selectedDoctor = nil
    selectedSlot = nil
    selectedSolicitud = nil
    slotsDisponibles = []
    selectedDate = Date()
    showSuccessAlert = false
    scheduledAppointmentId = nil
  }
  
  func resetSelection() {
    selectedSolicitud = nil
    selectedDoctor = nil
    selectedSlot = nil
    selectedDate = Date()
    slotsDisponibles = []
    state = .mostrandoSolicitudes
  }

  // MARK: - Ayudantes Privados

  private func cargarSolicitudes() async {
    state = .loading
    do {
      let data = try await service.fetchSolicitudes()
      solicitudes = data
      state = .mostrandoSolicitudes
    } catch let error as NetworkError {
      state = .error(error.errorDescription ?? "Error desconocido")
    } catch {
      state = .error("Error desconocido")
    }
  }
  
  func cargarDoctores() async {
    do {
      let data = try await service.fetchDoctores()
      doctores = data
      selectedDoctor = data.first
      if selectedDoctor != nil {
        await cargarDisponibilidad()
      }
      state = .seleccionandoDoctorHorario
    } catch let error as NetworkError {
      state = .error(error.errorDescription ?? "Error desconocido")
    } catch {
      state = .error("Error desconocido")
    }
  }

  private func cargarDisponibilidad() async {
    guard let doctor = selectedDoctor else { return }
    do {
      let slots = try await service.fetchDisponibilidad(doctorId: doctor.id, fecha: selectedDate)
      slotsDisponibles = slots
    } catch let error as NetworkError {
      state = .error(error.errorDescription ?? "Error desconocido")
    } catch {
      state = .error("Error desconocido")
    }
  }

  // MARK: - Colecciones Derivadas

  var filteredSolicitudes: [SolicitudCita] {
    guard !searchQuery.isEmpty else { return solicitudes }
    let query = searchQuery.lowercased()
    return solicitudes.filter {
      $0.paciente.user.nombreCompleto.localizedCaseInsensitiveContains(query) ||
      $0.appointment.doctor.user.nombreCompleto.localizedCaseInsensitiveContains(query) ||
      $0.tipoConsulta.localizedCaseInsensitiveContains(query)
    }
  }

  var availableSlots: [SlotDisponibilidad] {
    slotsDisponibles.filter { $0.disponible }
  }
  
  var fechasDisponibles: [Date] {
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: dateProvider())
    return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: today) }
  }
}
