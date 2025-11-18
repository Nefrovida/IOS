//
//  appointmentViewModel.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 15/11/25.
//

import Foundation
import SwiftUI
import Combine

// Represents a single appointment slot with a unique ID.
// Stores the slot's date and whether it is already occupied.
struct SlotEntity: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let isOccupied: Bool
}

@MainActor
final class appointmentViewModel: ObservableObject {
    // The currently selected day on the calendar.
    @Published var selectedDate: Date
    // List of generated slots for the selected day.
    @Published var slots: [SlotEntity] = []
    // Indicates whether data is currently loading.
    @Published var isLoading = false
    // Error message shown to the user if fetching fails.
    @Published var errorMessage: String?

    // The selected appointment slot (time), if any.
    @Published var selectedSlot: Date?
    // Stores the last successfully confirmed appointment date.
    @Published var lastConfirmedSlot: Date?
    
    // Calendar instance for date operations.
    private let calendar = Calendar(identifier: .gregorian)
    // Appointment type ID (ex: consultation, dialysis, etc.)
    private var appointmentId: Int

    // Use case for fetching existing appointments from the backend.
    private let getAppointmentsUC: GetAppointmentsUseCase
    // Use case for creating an appointment in the backend.
    private let createAppointmentUC: CreateAppointmentUseCase

    // Internal copy of appointmentId used when confirming appointments.
    private var currentAppointmentId: Int = 0

    init(
        getAppointmentsUC: GetAppointmentsUseCase,
        createAppointmentUC: CreateAppointmentUseCase,
        appointmentId: Int
    ) {
        self.getAppointmentsUC = getAppointmentsUC
        self.createAppointmentUC = createAppointmentUC
        self.appointmentId = appointmentId
        
        // Initializes with today's date at midnight.
        let calendar = Calendar.current
        self.selectedDate = calendar.startOfDay(for: Date())
    }

    // Loads available and occupied appointment slots for the selected date.
    // Generates hourly slots and marks them as occupied if they match retrieved appointments.
    func loadSlots() async {
        isLoading = true
        errorMessage = nil
        self.currentAppointmentId = self.appointmentId

        do {
            // Fetch previously booked appointments for this day & type
            let takenAppointments = try await getAppointmentsUC.execute(
                date: selectedDate,
                appointmentId: self.appointmentId
            )
            
            print("Citas ocupadas recibidas: \(takenAppointments.count)")
            print("Zona horaria local: \(TimeZone.current.identifier)")
            // Debug: print each appointment with local time zone conversion
            for apt in takenAppointments {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                print("   - ID: \(apt.id), Fecha UTC: \(apt.date), Local: \(formatter.string(from: apt.date))")
            }

            // Generated slots list
            var generatedSlots: [SlotEntity] = []

            var calendar = Calendar.current
            calendar.timeZone = TimeZone.current
            
            // Extract Y/M/D from selected date
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
            
            // Time range for appointments (8 AM - 6 PM)
            let startHour = 8
            let endHour = 18
            
            let now = Date()
            let isToday = calendar.isDateInToday(selectedDate)
            let isPastDay = selectedDate < calendar.startOfDay(for: now)

            // Generate hourly slots within working hours
            for hour in startHour...endHour {
                var components = dateComponents
                components.hour = hour
                components.minute = 0
                components.second = 0
                components.timeZone = TimeZone.current
                
                // Create the Date instance for this hour
                guard let date = calendar.date(from: components) else { continue }
                
                // Debug: print the generated slot
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                print("🔍 Slot local: \(formatter.string(from: date))")
                
                // Check whether this slot matches any occupied appointment
                let occupied = takenAppointments.contains { appointment in
                    let slotComps = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                    let aptComps = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: appointment.date)
                    
                    let isMatch = slotComps.year == aptComps.year &&
                                 slotComps.month == aptComps.month &&
                                 slotComps.day == aptComps.day &&
                                 slotComps.hour == aptComps.hour &&
                                 slotComps.minute == aptComps.minute
                    
                    if isMatch {
                        print("   ✅ OCUPADO - Coincide con cita ID: \(appointment.id)")
                    }
                    
                    return isMatch
                }
                
                // Mark slot as unavailable if:
                // - it’s already taken
                // - the selected day is in the past
                // - the slot time already passed today
                let isPastTime = isToday && now < date
                let finalOccupied = occupied || isPastDay || isPastTime
                
                print("   Estado: \(finalOccupied ? "🔴 OCUPADO" : "🟢 DISPONIBLE")")

                // Add new slot
                generatedSlots.append(
                    SlotEntity(date: date, isOccupied: finalOccupied)
                )
            }

            self.slots = generatedSlots
            print("Total de slots generados: \(generatedSlots.count)")

        } catch {
            print("Error en loadSlots: \(error.localizedDescription)")
            errorMessage = "Error cargando citas: \(error.localizedDescription)"
        }

        isLoading = false
    }

    // Confirms the currently selected slot and sends the request to the backend.
    func confirmSelectedSlot(userId: String) async -> Bool {
        guard let selected = selectedSlot else { return false }

        isLoading = true
        errorMessage = nil

        do {
            // Send request to backend to create the appointment
            let _ = try await createAppointmentUC.execute(
                userId: userId,
                appointmentId: currentAppointmentId,
                dateHour: selected
            )

            print("✅ Cita confirmada exitosamente")
            
            // Store last confirmed slot for the alert
            lastConfirmedSlot = selected

            // Clear the selection
            selectedSlot = nil
            
            // Refresh slots after booking
            await loadSlots()
            
            isLoading = false
            return true

        } catch {
            print("ERROR EN confirmSelectedSlot:", error.localizedDescription)
            errorMessage = "Error al confirmar la cita: \(error.localizedDescription)"
            isLoading = false
            return false
        }
    }
    
    // Generates the list of weekdays (Mon–Fri) for the week of the selected date.
    func generateWeekDays(from start: Date) -> [Date] {
        let calendar = Calendar.current
        // Finds the Monday of the current week
        let startOfWeek = calendar.date(
            from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: start)
        )!

        // Generates all 7 days
        let allDays = (0..<7).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: startOfWeek)
        }
        
        // Keep only Monday–Friday
        return allDays.filter { date in
            let weekday = calendar.component(.weekday, from: date)
            return weekday >= 2 && weekday <= 6
        }
    }
    
    // Returns the capitalized month name for the selected date.
    func monthTitle() -> String {
        let name = DateFormats.monthTitle.string(from: selectedDate)
        return name.prefix(1).uppercased() + name.dropFirst()
    }
    
    // Moves forward one week.
    func goNextWeek() {
        if let newDate = calendar.date(byAdding: .day, value: 7, to: selectedDate) {
            select(date: newDate)
        }
    }

    // Moves back one week.
    func goPrevWeek() {
        if let newDate = calendar.date(byAdding: .day, value: -7, to: selectedDate) {
            select(date: newDate)
        }
    }
    
    // Updates selected date and reloads slots.
    func select(date: Date) {
        let calendar = Calendar.current
        self.selectedDate = calendar.startOfDay(for: date)
        self.selectedSlot = nil
        
        Task { await loadSlots() }
    }
}

extension Date {
    // Converts UTC date to the system's local timezone.
    func convertToLocal() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return self.addingTimeInterval(seconds)
    }
}
