import SwiftUI

// Principal view that show a list of hours of the day and the dates (appointment).
struct AgendaList: View {
    //List of dates to show.
    let appointments: [Appointment]
    // The organization's working hours.
    private let hours = Array(8...18)

    var body: some View {
        VStack(spacing: 0) {
            // Create a row for each hour.
            ForEach(hours, id: \.self) { hour in
                HourRow(
                    hour: hour,
                    items: appointmentsFor(hour: hour) //Get the dates for that hour.
                )
            }
        }
    }

    //Func that get the appointments for that hour.
    private func appointmentsFor(hour: Int) -> [Appointment] {
        appointments
            //Apply a filter that match with the the hour.
            .filter { $0.dateHour.dropFirst(11).prefix(2) == String(format: "%02d", hour) }
            .sorted { ($0.place ?? "") < ($1.place ?? "") }
    }

    // Convert the string with the format "HH:mm" to a int with the hour.
    private func parseHour(_ hhmm: String) -> Int? {
        let comps = hhmm.split(separator: ":")
        guard let h = comps.first, let val = Int(h) else { return nil }
        return val
    }
}

// Represents a single row showing a specific hour and its associated appointments.
private struct HourRow: View {
    let hour: Int
    let items: [Appointment]

    //Chnage to a format of 12 hours.
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
                // Example (9 am).
                TimeLabel(text: label)

                // if there are not appointments, left a empty space.
                if items.isEmpty {
                    Rectangle().fill(.clear).frame(height: 0)
                } else {
                    //if there are appointments, show them.
                    VStack(spacing: 8) {
                        ForEach(items) { a in
                            AppointmentCard(appt: a)
                        }
                    }
                }
            }
            .padding(.horizontal)

            // Divider line.
            Divider()
                .padding(.leading, 64) // Keeps alignment between time label and appointment list.
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    HourRow(hour: 14, items: [])
}
