//
//  timeButton.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 14/11/25.
//

import SwiftUI

enum SlotState {
    case available
    case occupied
}

struct timeSelectable: View {
    let date: Date
    let state: SlotState
    let isSelected: Bool
    let onTap: () -> Void

    private var formatted: String {
        let f = DateFormatter()
        f.dateFormat = "hh:mm a"
        return f.string(from: date)
    }

    var body: some View {
        Text(formatted)
            .font(.body.weight(.medium))
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: isSelected ? 2 : 0)
            )
            .cornerRadius(12)
            .opacity(state == .occupied ? 0.35 : 1)
            .onTapGesture {
                if state == .available {
                    onTap()
                }
            }
            .disabled(state == .occupied)
    }

    private var backgroundColor: Color {
        if isSelected { return Color.blue.opacity(0.25) }

        switch state {
        case .available:
            return Color.green.opacity(0.20)
        case .occupied:
            return Color.red.opacity(0.25)
        }
    }

    private var borderColor: Color {
        isSelected ? Color.blue : .clear
    }
}

#Preview {
    VStack(spacing: 20) {
        timeSelectable(
            date: Date(),
            state: .available,
            isSelected: true
        ) {}

        timeSelectable(
            date: Date().addingTimeInterval(1800),
            state: .available,
            isSelected: false
        ) {}

        timeSelectable(
            date: Date().addingTimeInterval(3600),
            state: .occupied,
            isSelected: false
        ) {}
    }
    .padding()
}
