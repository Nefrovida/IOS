import SwiftUI

struct AppointmentCard: View {
    let appt: Appointment

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Tipo: \(appt.appointmentType)")
                .font(.nvSemibold)
                .foregroundColor(appt.appointmentType == "ANÁLISIS" ? .blue : .black)
                .font(.nvBody)
            Text("Lugar: \(appt.place ?? "No especificado")")
                .font(.nvBody)
                .foregroundStyle(.primary)
            Text("Fecha: \(appt.dateHour.prefix(10)) \(appt.dateHour.dropFirst(11).prefix(5))")
                .font(.nvSemibold)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.nvCardBlue)
        )
    }
}
