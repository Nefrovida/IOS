//
//  AppointmentRepository.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 16/11/25.
//

import Foundation

protocol appointmentRepository {
    func getAppointments(for date: Date, appointmentId: Int) async throws -> [AppointmentEntity]

    func createAppointment(
        userId: String,
        appointmentId: Int,
        dateHour: Date
    ) async throws -> AppointmentEntity
}
