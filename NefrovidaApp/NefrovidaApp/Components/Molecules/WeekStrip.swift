//
//  WeekStrip.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 08/11/25.
//

// Components/Molecules/WeekStrip.swift
import SwiftUI

struct WeekStrip: View {
    let days: [Date]
    let selected: Date
    let onSelect: (Date) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(days, id: \.self) { day in
                    Button { onSelect(day) } label: {
                        DayPill(date: day, isSelected: Calendar.current.isDate(day, inSameDayAs: selected))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.blue.opacity(0.12)))
        .padding(.horizontal)
    }
}

