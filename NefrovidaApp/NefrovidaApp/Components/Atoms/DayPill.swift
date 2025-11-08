//
//  DayPill.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 08/11/25.
//

// Components/Atoms/DayPill.swift
import SwiftUI

struct DayPill: View {
    let date: Date
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 6) {
            Text(DateFormats.weekDayShort.string(from: date))
                .font(.caption)
            Text(Calendar.current.component(.day, from: date).description)
                .font(.headline)
                .fontWeight(.semibold)
                .padding(8)
                .background(
                    Circle().fill(isSelected ? Color.indigo : Color.clear)
                )
                .foregroundStyle(isSelected ? .white : .primary)
        }
        .padding(.vertical, 6)
        .frame(minWidth: 44)
        .contentShape(Rectangle())
    }
}
