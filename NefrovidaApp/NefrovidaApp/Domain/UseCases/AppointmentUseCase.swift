//
//  GetAppointmentUseCase.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 16/11/25.
//

import Foundation

// UseCase responsible for retrieving appointments for a specific day.
// This layer isolates business logic from presentation (ViewModels)
// and from data sources (Repository).
struct GetAppointmentsUseCase {
    // Dependency injected repository (API, mock, local DB, etc.)
    let repository: appointmentRepository

    // Executes the use case.
    // Simply calls the repository and returns the entities.
    func execute(date: Date, appointmentId: Int) async throws -> [AppointmentEntity] {
        try await repository.getAppointments(for: date, appointmentId: appointmentId)
    }
}

import Foundation

// UseCase responsible for creating a new appointment.
// ViewModels interact with use cases, not directly with repositories.
struct CreateAppointmentUseCase {
    let repository: appointmentRepository

    // Executes the appointment creation flow.
    // Delegates to repository and returns the created AppointmentEntity.
    func execute(
        userId: String,
        appointmentId: Int,
        dateHour: Date
    ) async throws -> AppointmentEntity {
        try await repository.createAppointment(userId: userId, appointmentId: appointmentId, dateHour: dateHour)
    }
}
