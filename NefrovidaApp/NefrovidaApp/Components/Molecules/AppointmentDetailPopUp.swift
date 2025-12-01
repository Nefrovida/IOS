//
//  AppointmentDetailPopUp.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 30/11/25.
//
import SwiftUI

struct AppointmentDetailPopup: View {
    let appt: Appointment
    var dismiss: () -> Void
    
    @State private var showCancelAlert = false
    
    var body: some View {
        VStack(spacing: 24) {

            nefroPop(
                title: appt.appointmentInfo?.name ?? "Cita",
                description: "📆 Fecha: \(appt.localDate.formatted(date: .abbreviated, time: .shortened))",
                subtitle: "Lugar",
                indication: appt.place ?? "No especificado",
                buttonText: "Cancelar cita",
                buttonAction: { showCancelAlert = true },
                closeAction: dismiss
            )
        }
        .presentationDetents([.fraction(0.45), .medium]) // estilo bottom-sheet
        .presentationDragIndicator(.visible)
        .alert("Cancelar cita",
               isPresented: $showCancelAlert,
               actions: {
            Button("Cancelar", role: .destructive) { cancelAppointment() }
            Button("Volver", role: .cancel) {}
        },
               message: {
            Text("¿Estás seguro de cancelar tu cita?")
        })
    }

    private func cancelAppointment() {
        // Llamada al ViewModel
        NotificationCenter.default.post(
            name: .cancelAppointmentRequest,
            object: appt
        )
        dismiss()
    }
}

extension Notification.Name {
    static let cancelAppointmentRequest = Notification.Name("cancelAppointmentRequest")
}
