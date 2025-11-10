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
