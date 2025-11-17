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
