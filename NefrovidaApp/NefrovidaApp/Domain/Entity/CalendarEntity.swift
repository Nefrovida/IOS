import Foundation
// Domain entity that represents a medical appointment within the application.
// This model belongs to the **Domain Layer** in Clean Architecture.
// It defines the essential properties that describe an appointment, independent
// of how the data is stored, retrieved, or displayed in the UI.
public struct Appointment: Identifiable, Equatable {

    // Unique identifier automatically generated for each appointment instance.
    public let id: UUID = UUID()
    
    public let doctorName: String
    
    // Type of appointment (e.g., "Consulta", "Análisis clínico", "Revisión").
    public let appointmentType: String
    
    public let studyName: String
    
    // Appointment date in string format `"yyyy-MM-dd"`.
    public let date: String
    
    // Appointment hour in 24-hour string format `"HH:mm"`.
    public let hour: String
}
