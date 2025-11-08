//
//  o.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 08/11/25.
//

// Components/Organisms/AgendaList.swift
import SwiftUI

struct AgendaList: View {
    let appointments: [Appointment]

    private let timeline = ["8 am","9 am","10 am","11 am","12 am","1 pm","2 pm","3 pm"]

    var body: some View {
        VStack(spacing: 0) {
            // Primer bloque: si hay cita a las 8 am (demo similar a mock)
            if let first = appointments.first {
                HStack(alignment: .top, spacing: 12) {
                    TimeLabel(text: "8 am")
                    AppointmentCard(appt: first)
                }
                .padding(.horizontal)
                Divider().padding(.leading, 64)
            } else {
                // Sin citas a las 8 — mostramos línea
                HStack { TimeLabel(text: "8 am"); Rectangle().fill(Color.clear).frame(height: 0) }
                .padding(.horizontal)
                Divider().padding(.leading, 64)
            }

            ForEach(Array(timeline.dropFirst().enumerated()), id: \.offset) { _, t in
                HStack {
                    TimeLabel(text: t)
                    Rectangle().fill(.clear).frame(height: 0)
                }
                .padding(.horizontal)
                Divider().padding(.leading, 64)
            }
        }
    }
}
