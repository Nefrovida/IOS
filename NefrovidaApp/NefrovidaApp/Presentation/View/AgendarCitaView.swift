//
//  AgendarCitaView.swift
//  NefrovidaApp
//
//  Created by Leonardo Cervantes on 08/11/25.
//

import SwiftUI

struct AgendarCitaView: View {
  let solicitud: SolicitudCita
  @ObservedObject var viewModel: CitasViewModel
  @Environment(\.dismiss) private var dismiss
  @State private var showConfirmDialog = false

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(alignment: .leading, spacing: AppSpacing.xl) {
          PatientHeader(solicitud: solicitud)
          DoctorPickerSection(viewModel: viewModel)

          if viewModel.selectedDoctor != nil {
            DatePickerSection(viewModel: viewModel)
            TimeSlotsSection(viewModel: viewModel)
            scheduleButton
          }
        }
        .padding(AppSpacing.lg)
      }
      .navigationTitle("Agendar Cita")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancelar") {
            viewModel.resetSelection()
            dismiss()
          }
        }
      }
      .onAppear {
        Task {
          await viewModel.cargarDoctores()
        }
      }
      .alert("Confirmar Cita", isPresented: $showConfirmDialog) {
        Button("Cancelar", role: .cancel) {}
        Button("Confirmar") {
          Task {
            await viewModel.onProgramarCita()
          }
          dismiss()
        }
      } message: {
        if let doctor = viewModel.selectedDoctor,
           let slot = viewModel.selectedSlot {
          Text("¿Confirmar cita con \(doctor.nombreCompleto) el \(viewModel.selectedDate.format("dd/MM/yyyy")) a las \(slot.horario)?")
        }
      }
    }
  }

  private var scheduleButton: some View {
    PrimaryButton(
      title: "Programar Cita",
      action: { showConfirmDialog = true },
      isEnabled: viewModel.selectedDoctor != nil && viewModel.selectedSlot != nil,
      accessibilityLabel: "Programar cita médica"
    )
  }
}

// MARK: - Previews
#Preview {
  let mockService = MockNetworkService()
  mockService.solicitudes = [
    SolicitudCita(
      id: 1,
      patientId: "uuid-p1",
      appointmentId: 101,
      duracion: 45,
      tipoAppointment: "PRESENCIAL",
      status: "REQUESTED",
      paciente: SolicitudCita.PacienteDetalle(
        user: SolicitudCita.UserInfo(
          nombre: "María",
          apellidoPaterno: "Hernández",
          apellidoMaterno: "Gómez",
          telefono: "5552223333"
        )
      ),
      appointment: SolicitudCita.AppointmentDetalle(
        appointmentId: 101,
        doctorId: "doctor-uuid-1",
        name: "Consulta general",
        generalCost: "500",
        communityCost: "300",
        doctor: SolicitudCita.DoctorInAppointment(
          doctorId: "doctor-uuid-1",
          especialidad: "Nefrología",
          licencia: "LIC-001",
          user: SolicitudCita.UserInfo(
            nombre: "Ana",
            apellidoPaterno: "Martínez",
            apellidoMaterno: "Silva",
            telefono: "5559998888"
          )
        )
      )
    )
  ]
  
  return AgendarCitaView(
    solicitud: mockService.solicitudes[0],
    viewModel: CitasViewModel(service: mockService)
  )
}
