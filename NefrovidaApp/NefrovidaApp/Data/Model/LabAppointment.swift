//
//  LabAppointment.swift
//  NefrovidaApp
//
//  Created by Iván FV on 06/11/25.
//

import Foundation

enum LabAppointmentStatus: String, Codable {
    case pendiente, conResultados
}

struct LabAppointment: Identifiable, Codable, Equatable {
    let id: Int
    let patientName: String
    let analysisName: String
    let date: Date
    var status: LabAppointmentStatus
    var resultURI: URL?
}
