//
//  CitasViewModelTests.swift
//  NefrovidaAppTests
//
//  Created by Leonardo Cervantes on 08/11/25.
//

import XCTest
@testable import NefrovidaApp

final class CitasViewModelTests: XCTestCase {
  func testCargaSolicitudesSuccess() async {
    let mock = MockNetworkService()
    let solicitud = SolicitudCita(
      id: 1,
      patientId: "p1",
      appointmentId: 101,
      duracion: 45,
      tipoAppointment: "PRESENCIAL",
      status: "REQUESTED",
      paciente: SolicitudCita.PacienteDetalle(
        user: SolicitudCita.UserInfo(
          nombre: "John",
          apellidoPaterno: "Doe",
          apellidoMaterno: "",
          telefono: "5551234567"
        )
      ),
      appointment: SolicitudCita.AppointmentDetalle(
        appointmentId: 101,
        doctorId: "d1",
        name: "Consulta general",
        generalCost: "500",
        communityCost: "300",
        doctor: SolicitudCita.DoctorInAppointment(
          doctorId: "d1",
          especialidad: "Nefrología",
          licencia: "LIC-001",
          user: SolicitudCita.UserInfo(
            nombre: "Dr. Uno",
            apellidoPaterno: "Smith",
            apellidoMaterno: "",
            telefono: "5559876543"
          )
        )
      )
    )
    mock.solicitudes = [solicitud]
    let vm = CitasViewModel(service: mock)
    vm.onAgendarCitaScreenLoaded()
    try? await Task.sleep(nanoseconds: 50_000_000)
    XCTAssertEqual(vm.solicitudes.count, 1)
    XCTAssertEqual(vm.state, .mostrandoSolicitudes)
  }

  func testDisponibilidadLoadsAndSelectsFirstDoctor() async {
    let mock = MockNetworkService()
    let solicitud = SolicitudCita(
      id: 1,
      patientId: "p1",
      appointmentId: 101,
      duracion: 45,
      tipoAppointment: "PRESENCIAL",
      status: "REQUESTED",
      paciente: SolicitudCita.PacienteDetalle(
        user: SolicitudCita.UserInfo(
          nombre: "John",
          apellidoPaterno: "Doe",
          apellidoMaterno: "",
          telefono: "5551234567"
        )
      ),
      appointment: SolicitudCita.AppointmentDetalle(
        appointmentId: 101,
        doctorId: "d1",
        name: "Consulta general",
        generalCost: "500",
        communityCost: "300",
        doctor: SolicitudCita.DoctorInAppointment(
          doctorId: "d1",
          especialidad: "Nefrología",
          licencia: "LIC-001",
          user: SolicitudCita.UserInfo(
            nombre: "Dr. Uno",
            apellidoPaterno: "Smith",
            apellidoMaterno: "",
            telefono: "5559876543"
          )
        )
      )
    )
    mock.solicitudes = [solicitud]
    let doctor = DoctorDisponible(
      id: "d1",
      userId: "u1",
      especialidad: "Nefrología",
      licencia: "LIC-001",
      user: DoctorDisponible.UserDetalle(
        nombre: "Dr. Uno",
        apellidoPaterno: "Smith",
        apellidoMaterno: nil,
        telefono: "5559876543",
        activo: true
      )
    )
    mock.doctores = [doctor]
    mock.disponibilidad = [
      SlotDisponibilidad(inicio: Date(), fin: Date().addingTimeInterval(3600), disponible: true)
    ]
    let vm = CitasViewModel(service: mock)
    vm.onAgendarCitaScreenLoaded()
    try? await Task.sleep(nanoseconds: 50_000_000)
    vm.onSolicitudSeleccionada(idSolicitud: 1)
    try? await Task.sleep(nanoseconds: 50_000_000)
    XCTAssertEqual(vm.selectedDoctor?.id, doctor.id)
    XCTAssertEqual(vm.state, .seleccionandoDoctorHorario)
  }

  func testProgramarCitaConflict() async {
    let mock = MockNetworkService()
    let solicitud = SolicitudCita(
      id: 1,
      patientId: "p1",
      appointmentId: 101,
      duracion: 45,
      tipoAppointment: "PRESENCIAL",
      status: "REQUESTED",
      paciente: SolicitudCita.PacienteDetalle(
        user: SolicitudCita.UserInfo(
          nombre: "John",
          apellidoPaterno: "Doe",
          apellidoMaterno: "",
          telefono: "5551234567"
        )
      ),
      appointment: SolicitudCita.AppointmentDetalle(
        appointmentId: 101,
        doctorId: "d1",
        name: "Consulta general",
        generalCost: "500",
        communityCost: "300",
        doctor: SolicitudCita.DoctorInAppointment(
          doctorId: "d1",
          especialidad: "Nefrología",
          licencia: "LIC-001",
          user: SolicitudCita.UserInfo(
            nombre: "Dr. Uno",
            apellidoPaterno: "Smith",
            apellidoMaterno: "",
            telefono: "5559876543"
          )
        )
      )
    )
    mock.solicitudes = [solicitud]
    let doctor = DoctorDisponible(
      id: "d1",
      userId: "u1",
      especialidad: "Nefrología",
      licencia: "LIC-001",
      user: DoctorDisponible.UserDetalle(
        nombre: "Dr. Uno",
        apellidoPaterno: "Smith",
        apellidoMaterno: nil,
        telefono: "5559876543",
        activo: true
      )
    )
    mock.doctores = [doctor]
    mock.disponibilidad = [
      SlotDisponibilidad(inicio: Date(), fin: Date().addingTimeInterval(3600), disponible: true)
    ]
    mock.shouldThrowConflict = true
    let vm = CitasViewModel(service: mock)
    vm.onAgendarCitaScreenLoaded()
    try? await Task.sleep(nanoseconds: 50_000_000)
    vm.onSolicitudSeleccionada(idSolicitud: 1)
    try? await Task.sleep(nanoseconds: 50_000_000)
    vm.selectedSlot = mock.disponibilidad.first
    await vm.onProgramarCita()
    if case .error(let message) = vm.state {
      XCTAssertTrue(message.contains("no está disponible"))
    } else {
      XCTFail("Se esperaba estado de error por conflicto")
    }
  }

  func testProgramarCitaSuccess() async {
    let mock = MockNetworkService()
    let solicitud = SolicitudCita(
      id: 1,
      patientId: "p1",
      appointmentId: 101,
      duracion: 45,
      tipoAppointment: "PRESENCIAL",
      status: "REQUESTED",
      paciente: SolicitudCita.PacienteDetalle(
        user: SolicitudCita.UserInfo(
          nombre: "John",
          apellidoPaterno: "Doe",
          apellidoMaterno: "",
          telefono: "5551234567"
        )
      ),
      appointment: SolicitudCita.AppointmentDetalle(
        appointmentId: 101,
        doctorId: "d1",
        name: "Consulta general",
        generalCost: "500",
        communityCost: "300",
        doctor: SolicitudCita.DoctorInAppointment(
          doctorId: "d1",
          especialidad: "Nefrología",
          licencia: "LIC-001",
          user: SolicitudCita.UserInfo(
            nombre: "Dr. Uno",
            apellidoPaterno: "Smith",
            apellidoMaterno: "",
            telefono: "5559876543"
          )
        )
      )
    )
    mock.solicitudes = [solicitud]
    let doctor = DoctorDisponible(
      id: "d1",
      userId: "u1",
      especialidad: "Nefrología",
      licencia: "LIC-001",
      user: DoctorDisponible.UserDetalle(
        nombre: "Dr. Uno",
        apellidoPaterno: "Smith",
        apellidoMaterno: nil,
        telefono: "5559876543",
        activo: true
      )
    )
    mock.doctores = [doctor]
    mock.disponibilidad = [
      SlotDisponibilidad(inicio: Date(), fin: Date().addingTimeInterval(3600), disponible: true)
    ]
    let vm = CitasViewModel(service: mock)
    vm.onAgendarCitaScreenLoaded()
    try? await Task.sleep(nanoseconds: 50_000_000)
    vm.onSolicitudSeleccionada(idSolicitud: 1)
    try? await Task.sleep(nanoseconds: 50_000_000)
    vm.selectedSlot = mock.disponibilidad.first
    await vm.onProgramarCita()
    XCTAssertTrue(vm.showSuccessAlert)
  }
}
