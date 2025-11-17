//
//  AppointmentEntity.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 16/11/25.
//

import Foundation

struct AppointmentEntity: Identifiable {
    let id: Int
    let appointmentId: Int
    let date: Date
    let duration: Int
    let status: String
    let patientName: String?
}
