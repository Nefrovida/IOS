//
//  AppointmentRepository.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 16/11/25.
//

import Foundation

// Protocol that defines the contract for any appointment repository.
// This allows you to:
// - Swap the data source easily (e.g., real API, mock data, offline mode)
// - Write unit tests by mocking the repository
// - Keep the ViewModels independent of networking logic
protocol appointmentRepository {
    // Fetch all appointments for a given date and appointment type.
    // The function is asynchronous and can throw errors (network/decoding).
    func getAppointments(for date: Date, appointmentId: Int) async throws -> [AppointmentEntity]

    // Creates a new appointment for a user at a specific date and time.
    // Also asynchronous and throwable.
    func createAppointment(
        userId: String,
        appointmentId: Int,
        dateHour: Date
    ) async throws -> AppointmentEntity
}
