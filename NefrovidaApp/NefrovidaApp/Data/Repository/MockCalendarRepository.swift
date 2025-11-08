//
//  MockCalendarRepository.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 08/11/25.
//

// Data/Repository/MockAppointmentRepository.swift
import Foundation

public final class MockAppointmentRepository: AppointmentRepository {
    public init() {}
    public func fetchAppointments(forDate date: String) async throws -> [Appointment] {
        // demo: una cita a las 08:00
        return [
            Appointment(doctorName: "Manuel Bajos",
                        appointmentType: "Análisis",
                        studyName: "Biometría Hemática (BM)",
                        date: date,
                        hour: "08:00")
        ]
    }
}
