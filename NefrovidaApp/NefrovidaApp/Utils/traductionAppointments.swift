//
//  traductionAppointments.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 22/11/25.
//

//
//  ColorStatus.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 21/11/25.
//

import Foundation

extension String {
    var appointmentStatusSpanish: String {
        switch self.uppercased() {
        case "FINISHED":
            return "Finalizado"
        case "PROGRAMMED":
            return "Programado"
        case "REQUESTED":
            return "Solicitado"
        case "MISSED":
            return "Perdido"
        case "CANCELED":
            return "Cancelado"
        case "SENT":
            return "Enviado"
        case "PENDING":
            return "Pendiente"
        case "LAB":
            return "En Laboratorio"
        default:
            return self    // por si llega uno nuevo
        }
    }
}
