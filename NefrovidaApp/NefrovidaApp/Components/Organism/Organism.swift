//
//  Organism.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 28/10/25.
//

import SwiftUI

// MARK: - Appointment Request Card Organism
struct SolicitudCard: View {
  let solicitud: SolicitudCita
  let onAgendar: () -> Void

  var body: some View {
    HStack(alignment: .top, spacing: AppSpacing.md) {
      AvatarView(urlString: nil, name: solicitud.paciente.user.nombreCompleto, size: 48)
        .accessibilityHidden(true)

      VStack(alignment: .leading, spacing: AppSpacing.xs) {
        Text(solicitud.paciente.user.nombreCompleto)
          .font(AppTypography.headline)
          .foregroundColor(Theme.blueDark)
        Text(solicitud.tipoConsulta)
          .font(AppTypography.subheadline)
          .foregroundColor(Theme.graySecondary)
        Text(solicitud.fechaSolicitud.format("dd-MM-yyyy"))
          .font(AppTypography.caption)
          .foregroundColor(Theme.graySecondary)
      }
      Spacer()
      CapsuleButton(title: "Agendar", action: onAgendar, accessibilityLabel: "Agendar cita para \(solicitud.paciente.user.nombreCompleto)")
    }
    .cardStyle()
    .padding(.horizontal, AppSpacing.md)
  }
}

// MARK: - Patient Header Organism
struct PatientHeader: View {
  let solicitud: SolicitudCita

  var body: some View {
    HStack(spacing: AppSpacing.md) {
      AvatarView(urlString: nil, name: solicitud.paciente.user.nombreCompleto, size: 48)
      VStack(alignment: .leading) {
        Text(solicitud.paciente.user.nombreCompleto)
          .font(AppTypography.headline)
        Text(solicitud.tipoConsulta)
          .font(AppTypography.subheadline)
          .foregroundColor(Theme.graySecondary)
      }
      Spacer()
    }
    .cardStyle()
  }
}

// MARK: - Doctor Picker Organism
struct DoctorPickerSection: View {
  @ObservedObject var viewModel: CitasViewModel

  var body: some View {
    VStack(alignment: .leading, spacing: AppSpacing.sm) {
      Text("Seleccione un doctor:")
        .font(AppTypography.headline)
        .foregroundColor(Theme.blueDark)

      Menu {
        ForEach(viewModel.doctores, id: \.id) { doctor in
          Button(action: {
            viewModel.selectedDoctor = doctor
            viewModel.onDoctorSeleccionado(doctorId: doctor.id)
          }) {
            HStack {
              VStack(alignment: .leading) {
                Text(doctor.nombreCompleto)
                Text(doctor.especialidad.trimmingCharacters(in: .whitespaces))
                  .font(AppTypography.caption)
              }
              if doctor == viewModel.selectedDoctor {
                Image(systemName: "checkmark")
              }
            }
          }
        }
      } label: {
        HStack {
          if let doctor = viewModel.selectedDoctor {
            VStack(alignment: .leading) {
              Text(doctor.nombreCompleto)
              Text(doctor.especialidad.trimmingCharacters(in: .whitespaces))
                .font(AppTypography.caption)
                .foregroundColor(Theme.graySecondary)
            }
          } else {
            Text("Seleccione")
          }
          Spacer()
          Image(systemName: "chevron.down")
        }
        .padding(AppSpacing.md)
        .background(Theme.secondaryBackground)
        .cornerRadius(AppCornerRadius.md)
      }
      .accessibilityLabel("Seleccionar doctor")
    }
    .cardStyle()
  }
}

// MARK: - Date Picker Organism
struct DatePickerSection: View {
  @ObservedObject var viewModel: CitasViewModel

  var body: some View {
    VStack(alignment: .leading, spacing: AppSpacing.sm) {
      Text("Seleccione la fecha:")
        .font(AppTypography.headline)
        .foregroundColor(Theme.blueDark)

      DatePicker("", selection: $viewModel.selectedDate, in: Date()..., displayedComponents: .date)
        .datePickerStyle(.graphical)
        .onChange(of: viewModel.selectedDate) { _, newValue in
          viewModel.onDateChanged(newValue)
        }
    }
    .cardStyle()
  }
}

// MARK: - Time Slots Organism
struct TimeSlotsSection: View {
  @ObservedObject var viewModel: CitasViewModel

  var body: some View {
    VStack(alignment: .leading, spacing: AppSpacing.md) {
      Text("Horarios disponibles:")
        .font(AppTypography.headline)
        .foregroundColor(Theme.blueDark)

      LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: AppSpacing.md) {
        ForEach(viewModel.availableSlots, id: \.inicio) { slot in
          let isSelected = viewModel.selectedSlot?.inicio == slot.inicio
          CapsuleButton(
            title: slot.horario,
            action: { viewModel.selectedSlot = slot },
            isSelected: isSelected,
            accessibilityLabel: "Horario \(slot.horario)"
          )
        }
      }
    }
    .cardStyle()
  }
}
