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
    public static let shortTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    public static let monthTitle: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()
}

extension DateFormats {
    static func isoTo(_ isoString: String, format: String = "dd/MM/yyyy") -> String {
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let date = iso.date(from: isoString) else {
            return isoString // fallback si falla
        }

        let output = DateFormatter()
        output.locale = Locale(identifier: "es_MX")
        output.dateFormat = format
        return output.string(from: date)
    }
}
