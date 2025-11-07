//
//  Appointment.swift
//  NefrovidaApp
//
//  Created by Iván FV on 06/11/25.
//

import Foundation

enum AppointmentStatus: String, Codable {
    case pendiente, conResultados
}

struct Appointment: Identifiable, Codable, Equatable {
    let id: Int
    let patientName: String
    let analysisName: String
    let date: Date
    var status: AppointmentStatus
    var resultURI: URL?
}
