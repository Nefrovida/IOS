//
//  DatesFormats.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 08/11/25.
//

// Presentation/Utils/DateFormats.swift
import Foundation

enum DateFormats {
    static let apiDay: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "es_MX")
        f.timeZone = .current
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
    static let weekDayShort: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "es_MX")
        f.dateFormat = "EEE"
        return f
    }()
    static let monthTitle: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "es_MX")
        f.dateFormat = "LLLL"
        return f
    }()
}
