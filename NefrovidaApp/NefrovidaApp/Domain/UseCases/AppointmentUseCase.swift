//
//  GetAppointmentUseCase.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 16/11/25.
//

import Foundation

struct GetAppointmentsUseCase {
    let repository: appointmentRepository

    func execute(date: Date, appointmentId: Int) async throws -> [AppointmentEntity] {
        try await repository.getAppointments(for: date, appointmentId: appointmentId)
    }
}

import Foundation

struct CreateAppointmentUseCase {
    let repository: appointmentRepository

    func execute(
        userId: String,
        appointmentId: Int,
        dateHour: Date
    ) async throws -> AppointmentEntity {
        try await repository.createAppointment(userId: userId, appointmentId: appointmentId, dateHour: dateHour)
    }
}
