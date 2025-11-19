//
//  timeButton.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 14/11/25.
//

import SwiftUI

// Represents the state of a time slot
// - available = the time slot is free
// - occupied = the time slot is taken
enum SlotState {
    case available
    case occupied
}

struct timeSelectable: View {
    let date: Date
    let state: SlotState
    let isSelected: Bool
    let onTap: () -> Void

    // Formats the date into a readable hour string (e.g., "03:30 PM")
    private var formatted: String {
        let f = DateFormatter()
        f.dateFormat = "hh:mm a"
        return f.string(from: date)
    }

    var body: some View {
        // Display the formatted time
        Text(formatted)
            .font(.body.weight(.medium))
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            // Background depends on availability and selection
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: isSelected ? 2 : 0)
            )
            .cornerRadius(12)
            // Lower opacity if the slot is occupied
            .opacity(state == .occupied ? 0.35 : 1)
            // Only trigger tap if the slot is available
            .onTapGesture {
                if state == .available {
                    onTap()
                }
            }
            // Disable interaction completely when occupied
            .disabled(state == .occupied)
    }

    // Determines the background color based on state and selection
    private var backgroundColor: Color {
        // Light blue if selected
        if isSelected { return Color.blue.opacity(0.25) }

        // Green for available, red for occupied
        switch state {
        case .available:
            return Color.green.opacity(0.20)
        case .occupied:
            return Color.red.opacity(0.25)
        }
    }

    // Border color when selected
    private var borderColor: Color {
        isSelected ? Color.blue : .clear
    }
}

// SwiftUI preview for the component
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
