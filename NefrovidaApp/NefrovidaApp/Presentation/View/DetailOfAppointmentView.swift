//
//  DetailOfAppointmentView.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 30/11/25.
//

import SwiftUI

struct AppointmentDetailSheet: View {
    let appt: Appointment
    let onCancel: () -> Void

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                Text(appt.appointmentInfo?.name.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Sin nombre")
                    .font(.title3.bold())

                Text("Fecha: \(appt.localDate.formatted(date: .abbreviated, time: .omitted))")
                Text("Hora: \(appt.localHourString)")
                Text("Tipo: \(appt.appointmentType)")
                Text("Lugar: \(appt.place ?? "No especificado")")
                Text("Estatus: \(appt.appointmentStatus.appointmentStatusSpanish)")

                Spacer()

                nefroButton(
                    text: "Cancelar cita",
                    color: .red,
                    textColor: .white,
                    vertical: 12,
                    horizontal: 16,
                    hasStroke: false,
                    textSize: 16,
                    action: onCancel
                )
            }
            .padding()
            .navigationTitle("Detalle de cita")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
