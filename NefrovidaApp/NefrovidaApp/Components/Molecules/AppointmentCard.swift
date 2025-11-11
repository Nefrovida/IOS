//
//  AppointmentCard.swift
//  NefrovidaApp
//
//  Created by Iván FV on 08/11/25.
//
// Components/Molecules/AppointmentCard.swift

import SwiftUI

struct AppointmentCard: View {
    let appt: Appointment

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Doctor: \(appt.doctorName)")
                .font(.nvSemibold)
            Text("Tipo de cita: \(appt.appointmentType)")
                .font(.nvBody)
            Text("Estudio a realizar: \(appt.studyName)")
                .font(.nvBody)
                .foregroundStyle(.primary)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.nvCardBlue)
        )
    }
}

// ======= Tu versión: renombrada a AppointmentCardNV =======
struct AppointmentCardNV: View {
    let patientName: String
    let analysisName: String
    let dateText: String
    let status: AppointmentStatus

    var body: some View {
        HStack(spacing: 14) {
            AvatarCircle()

            VStack(alignment: .leading, spacing: 4) {
                Text(patientName)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(analysisName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(dateText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 8)

            Group {
                switch status {
                case .pendiente:
                    StatusChip(kind: .pendiente)
                case .conResultados:
                    StatusChip(kind: .entregado)
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(NV.cardBG)
        )
        .nvShadow(NV.elevation(1))
    }
}
