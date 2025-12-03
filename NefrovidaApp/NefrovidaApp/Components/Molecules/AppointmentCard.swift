import SwiftUI

struct AppointmentCard: View {
    let appt: Appointment
    //let analysis: Analysis?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            Text("Cita: \(titleText)")
                .font(.nvSemibold)
                .foregroundColor(.primary)
            
            Text("Tipo: \(appt.appointmentType)")
                .font(.nvSemibold)
                .foregroundColor(.primary)

            Text("Lugar: \(appt.place ?? "No especificado")")
                .font(.nvBody)
                .foregroundStyle(.primary)

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
                .stroke(Color.statusColor(for: appt.appointmentStatus).opacity(0.8), lineWidth: 2)
        )
    }

    private var titleText: String {
        appt.appointmentInfo?.name.trimmingCharacters(in: .whitespaces)
        //?? analysis?.name
        ?? "Sin nombre"
    }
}
