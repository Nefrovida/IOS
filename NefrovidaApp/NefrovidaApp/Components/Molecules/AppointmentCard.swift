import SwiftUI

struct AppointmentCard: View {
    let appt: Appointment
    let onTap: () -> Void

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

            Text("Estatus: \(appt.appointmentStatus)")
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
        .onTapGesture { onTap() }
    }

    private var apptTitle: String {
        appt.appointmentInfo?.name.trimmingCharacters(in: .whitespacesAndNewlines)
        ?? "Sin nombre"
    }
}

struct AppointmentPopup: View {
    let appt: Appointment
    let onCancel: () -> Void
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text(appt.appointmentInfo?.name ?? "Sin nombre")
                .font(.title2)
                .bold()

            Text("Hora: \(appt.localHourString)")
            Text("Lugar: \(appt.place ?? "No especificado")")
            Text("Tipo: \(appt.appointmentType)")

            Button(role: .destructive) {
                onCancel()
            } label: {
                Text("Cancelar cita")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.15))
                    .cornerRadius(10)
            }

            Button("Cerrar") {
                onClose()
            }
        }
        .padding(22)
        .background(.thinMaterial)
        .cornerRadius(18)
        .shadow(radius: 10)
        .frame(maxWidth: 350)
    }
}
