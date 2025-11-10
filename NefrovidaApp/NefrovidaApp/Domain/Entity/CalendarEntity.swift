import Foundation

public struct Appointment: Identifiable, Equatable {
    public let id: UUID = UUID()
    public let doctorName: String
    public let appointmentType: String
    public let studyName: String
    public let date: String      // "yyyy-MM-dd"
    public let hour: String      // "HH:mm"
}
