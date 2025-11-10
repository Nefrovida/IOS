//
//  AppointmentCard.swift
//  NefrovidaApp
//
//  Created by Iván FV on 08/11/25.
//

import SwiftUI

struct AppointmentCard: View {
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
