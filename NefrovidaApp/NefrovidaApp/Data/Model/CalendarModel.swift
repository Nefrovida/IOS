//
//  CalendarModel.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 08/11/25.
//

// Data/Model/AppointmentDTO.swift
import Foundation

struct AppointmentDTO: Codable {
    let doctorName: String
    let appointmentType: String
    let studyName: String
    let date: String   // "yyyy-MM-dd"
    let hour: String   // "HH:mm"

    func toDomain() -> Appointment {
        Appointment(doctorName: doctorName,
                    appointmentType: appointmentType,
                    studyName: studyName,
                    date: date,
                    hour: hour)
    }
}
