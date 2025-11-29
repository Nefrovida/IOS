import SwiftUI

struct AppointmentCard: View {
    let appt: Appointment

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            Text(apptTitle)
                .font(.nvSemibold)

            Text("Hora: \(appt.localHourString)")
                .font(.nvBody)
                .foregroundStyle(.primary)

            Text("Tipo: \(appt.appointmentType)")
                .font(.nvSemibold)

            Text("Lugar: \(appt.place ?? "No especificado")")
                .font(.nvBody)

            Text("Estatus: \(appt.appointmentStatus.appointmentStatusSpanish)")
                .font(.nvSemibold)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.statusColor(for: appt.appointmentStatus))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    Color.statusColor(for: appt.appointmentStatus).opacity(0.8),
                    lineWidth: 2
                )
        )
    }

    private var apptTitle: String {
        appt.appointmentInfo?.name.trimmingCharacters(in: .whitespacesAndNewlines)
        ?? "Sin nombre"
    }
}
