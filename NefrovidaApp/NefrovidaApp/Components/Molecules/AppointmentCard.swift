import SwiftUI

struct AppointmentCard: View {
    let appt: Appointment
    @State private var showPopup = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            Text(apptTitle).font(.nvSemibold)
            Text("Hora: \(appt.localHourString)").font(.nvBody)
            Text("Tipo: \(appt.appointmentType)").font(.nvSemibold)
            Text("Lugar: \(appt.place ?? "No especificado")").font(.nvBody)
            Text("Estatus: \(appt.appointmentStatus.appointmentStatusSpanish)").font(.nvSemibold)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.statusColor(for: appt.appointmentStatus))
        )
        .onTapGesture { showPopup = true }
        .sheet(isPresented: $showPopup) {
            AppointmentDetailPopup(appt: appt, dismiss: { showPopup = false })
        }
    }

    private var apptTitle: String {
        appt.appointmentInfo?.name.trimmingCharacters(in: .whitespacesAndNewlines)
            ?? "Sin nombre"
    }
}
