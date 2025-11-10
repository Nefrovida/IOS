// Components/Organisms/AgendaList.swift
import SwiftUI

struct AgendaList: View {
    let appointments: [Appointment]   // del VM para el día
    private let hours = Array(8...18) // 8am-6pm

    var body: some View {
        VStack(spacing: 0) {
            ForEach(hours, id: \.self) { hour in
                HourRow(hour: hour,
                        items: appointmentsFor(hour: hour))
            }
        }
    }

    private func appointmentsFor(hour: Int) -> [Appointment] {
        appointments.filter { parseHour($0.hour) == hour }
                    .sorted { $0.studyName < $1.studyName }
    }

    private func parseHour(_ hhmm: String) -> Int? {
        // admite "08:00" o "8:00"
        let comps = hhmm.split(separator: ":")
        guard let h = comps.first, let val = Int(h) else { return nil }
        return val
    }
}

private struct HourRow: View {
    let hour: Int
    let items: [Appointment]

    var label: String {
        if hour == 12 { return "12 pm" }
        if hour == 0  { return "12 am" }
        if hour < 12  { return "\(hour) am" }
        if hour == 24 { return "12 am" }
        return "\(hour == 12 ? 12 : hour - 12) pm"
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                TimeLabel(text: label)
                if items.isEmpty {
                    Rectangle().fill(.clear).frame(height: 0)
                } else {
                    VStack(spacing: 8) {
                        ForEach(items) { a in
                            AppointmentCard(appt: a)
                        }
                    }
                }
            }
            .padding(.horizontal)

            Divider().padding(.leading, 64)
        }
        .padding(.vertical, 6)
    }
}


#Preview {
    HourRow(hour: 14, items: [])
}
