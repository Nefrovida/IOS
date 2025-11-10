//
//  SolicitudesCitaView.swift
//  NefrovidaApp
//
//  Created by Leonardo Cervantes on 08/11/25.
//

import SwiftUI

struct SolicitudesCitaView: View {
  @StateObject private var viewModel = CitasViewModel()
  @State private var showFilterSheet = false

  var body: some View {
    NavigationStack {
      Group {
        switch viewModel.state {
        case .idle, .loading:
          ProgressView("Cargando solicitudes…")
            .progressViewStyle(.circular)
            .accessibilityLabel(Text("Cargando solicitudes"))
        case .mostrandoSolicitudes:
          listContent
        case .seleccionandoDoctorHorario:
          listContent
            .sheet(isPresented: Binding(
              get: { viewModel.selectedSolicitud != nil && viewModel.state == .seleccionandoDoctorHorario },
              set: { _ in }
            )) {
              if let solicitud = viewModel.selectedSolicitud {
                AgendarCitaView(solicitud: solicitud, viewModel: viewModel)
              }
            }
        case .error(let message):
          VStack(spacing: AppSpacing.lg) {
            Image(systemName: "exclamationmark.triangle.fill")
              .font(AppTypography.largeTitle)
              .foregroundColor(.orange)
            Text(message)
              .multilineTextAlignment(.center)
            SecondaryButton(title: "Reintentar", action: { viewModel.onAgendarCitaScreenLoaded() })
          }
          .padding(AppSpacing.lg)
        }
      }
      .navigationTitle("Solicitudes de cita")
      .toolbar {
        #if os(iOS)
        ToolbarItem(placement: .navigationBarTrailing) {
          Button { showFilterSheet.toggle() } label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
          }
          .accessibilityLabel("Filtros")
          .sheet(isPresented: $showFilterSheet) {
            Text("Filtros próximamente")
              .padding(AppSpacing.lg)
          }
        }
        #endif
      }
      .alert("¡Cita Programada!", isPresented: $viewModel.showSuccessAlert) {
        Button("Listo") {
          viewModel.resetAfterConfirmation()
        }
      } message: {
        if let solicitud = viewModel.selectedSolicitud,
           let doctor = viewModel.selectedDoctor,
           let slot = viewModel.selectedSlot {
          Text("""
          Paciente: \(solicitud.paciente.user.nombreCompleto)
          Tipo: \(solicitud.tipoConsulta)
          
          Doctor: \(doctor.nombreCompleto)
          Especialidad: \(doctor.especialidad.trimmingCharacters(in: .whitespaces))
          
          Fecha: \(viewModel.selectedDate.format("dd/MM/yyyy"))
          Hora: \(slot.horario)
          """)
        }
      }
    }
    #if os(iOS)
    .searchable(text: $viewModel.searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Buscar paciente o examen")
    #endif
    .onAppear { viewModel.onAgendarCitaScreenLoaded() }
  }

  private var listContent: some View {
    List(viewModel.filteredSolicitudes) { solicitud in
      SolicitudCard(solicitud: solicitud) {
        viewModel.onSolicitudSeleccionada(idSolicitud: solicitud.id)
      }
      .listRowSeparator(.hidden)
      .listRowInsets(EdgeInsets())
      .padding(.vertical, AppSpacing.sm)
    }
    .listStyle(.plain)
  }
}

#Preview {
  SolicitudesCitaView()
}