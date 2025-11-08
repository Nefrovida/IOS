//
//  CalendarRepository.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 08/11/25.
//

// Domain/Repository/AppointmentRepository.swift
import Foundation

public protocol AppointmentRepository {
    func fetchAppointments(forDate date: String) async throws -> [Appointment]
}
