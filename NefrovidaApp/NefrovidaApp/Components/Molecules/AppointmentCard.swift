//
//  AppointmentCard.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 08/11/25.
//

// Components/Molecules/AppointmentCard.swift
import SwiftUI

struct AppointmentCard: View {
    let appt: Appointment
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Doctor: \(appt.doctorName)").font(.subheadline).fontWeight(.semibold)
            Text("Tipo de cita: \(appt.appointmentType)").font(.subheadline)
            Text("Estudio a realizar: \(appt.studyName)").font(.subheadline)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.08))
        )
    }
}
