//
//  RescheduleView.swift
//  NefrovidaApp
//
//  Created on 02/12/25.
//

import SwiftUI

struct RescheduleAppointmentView: View {
    let appointmentToCancel: Appointment
    let userId: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Group {
            if appointmentToCancel.appointmentType.uppercased() == "ANÁLISIS" {
                // Reagendar análisis
                analysisView(
                    analysisId: appointmentToCancel.id,
                    userId: userId,
                    // Closure que se ejecuta al confirmar el nuevo horario
                    onConfirm: {
                        Task { await cancelPreviousAnalysis() }
                    }
                )
            } else {
                // Reagendar cita normal
                appointmentView(
                    appointmentId: appointmentToCancel.id,
                    userId: userId,
                    onConfirm: {
                        Task { await cancelPreviousAppointment() }
                    }
                )
            }
        }
        .navigationTitle("Reagendar Horario")
    }
    
    // Cancelación del análisis anterior
    private func cancelPreviousAnalysis() async {
        let calendarRepo = RemoteAppointmentRepository()
        let calendarUC = GetAppointmentsForDayUseCase(repository: calendarRepo)
        let cancelVM = AgendaViewModel(getAppointmentsUC: calendarUC, idUser: userId)
        _ = await cancelVM.cancelSpecificAppointment(appointmentToCancel)
    }
    
    // Cancelación de la cita anterior
    private func cancelPreviousAppointment() async {
        let calendarRepo = RemoteAppointmentRepository()
        let calendarUC = GetAppointmentsForDayUseCase(repository: calendarRepo)
        let cancelVM = AgendaViewModel(getAppointmentsUC: calendarUC, idUser: userId)
        _ = await cancelVM.cancelSpecificAppointment(appointmentToCancel)
    }
}
