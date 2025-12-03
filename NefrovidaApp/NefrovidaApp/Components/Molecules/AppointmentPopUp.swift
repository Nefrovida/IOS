//
//  AppointmentPopUp.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 03/12/25.
//

import SwiftUI

struct AppointmentPopUp: View {
    let appointment: Appointment
    let onCancel: () -> Void
    let onReschedule: () -> Void
    let onClose: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text(appointment.appointmentInfo?.name ?? appointment.appointmentType)
                .font(.title3)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                DetailRow(label: "Hora:", value: appointment.localHourString)
                
                if let place = appointment.place {
                    DetailRow(label: "Lugar:", value: place)
                }
                
                DetailRow(label: "Tipo:", value: appointment.appointmentType.uppercased())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            VStack(spacing: 12) {
                Button(action: onCancel) {
                    Text("Cancelar cita")
                        .font(.system(size: 16, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.red.opacity(0.1))
                        .foregroundColor(.red)
                        .cornerRadius(10)
                }
                
                Button(action: onReschedule) {
                    Text("Reagendar")
                        .font(.system(size: 16, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                }
                
                Button(action: onClose) {
                    Text("Cerrar")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
        )
        .padding(.horizontal, 40)
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 15))
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.system(size: 15, weight: .medium))
        }
    }
}

#Preview() {
    ZStack {
        Color.black.opacity(0.4)
            .ignoresSafeArea()
        
        AppointmentPopUp(
            appointment: Appointment(
                patientAppointmentId: 123,
                patientId: "patient-001",
                appointmentId: 456,
                dateHour: "2024-12-05T10:00:00.000Z",
                duration: 30,
                appointmentType: "Consulta",
                link: nil,
                place: "Consultorio 201",
                appointmentStatus: "confirmed",
                appointmentInfo: AppointmentInfo(name: "Consulta Cardiológica")
            ),
            onCancel: { print("Cancelar presionado") },
            onReschedule: { print("Reagendar presionado") },
            onClose: { print("Cerrar presionado") }
        )
    }
}
