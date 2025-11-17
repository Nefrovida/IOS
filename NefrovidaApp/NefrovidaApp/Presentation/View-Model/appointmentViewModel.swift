//
//  appointmentViewModel.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 15/11/25.
//

import Foundation
import SwiftUI
import Combine

struct SlotEntity: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let isOccupied: Bool
}

@MainActor
final class agendaViewModel: ObservableObject {

    @Published var selectedDate: Date
    @Published var slots: [SlotEntity] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    @Published var selectedSlot: Date?
    @Published var lastConfirmedSlot: Date?
    
    private let calendar = Calendar(identifier: .gregorian)
    private var appointmentId: Int

    private let getAppointmentsUC: GetAppointmentsUseCase
    private let createAppointmentUC: CreateAppointmentUseCase

    private var currentAppointmentId: Int = 0

    init(
        getAppointmentsUC: GetAppointmentsUseCase,
        createAppointmentUC: CreateAppointmentUseCase,
        appointmentId: Int
    ) {
        self.getAppointmentsUC = getAppointmentsUC
        self.createAppointmentUC = createAppointmentUC
        self.appointmentId = appointmentId
        
        let calendar = Calendar.current
        self.selectedDate = calendar.startOfDay(for: Date())
    }

    func loadSlots() async {
        isLoading = true
        errorMessage = nil
        self.currentAppointmentId = self.appointmentId

        do {
            let takenAppointments = try await getAppointmentsUC.execute(
                date: selectedDate,
                appointmentId: self.appointmentId
            )
            
            print("Citas ocupadas recibidas: \(takenAppointments.count)")
            print("Zona horaria local: \(TimeZone.current.identifier)")
            for apt in takenAppointments {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                print("   - ID: \(apt.id), Fecha UTC: \(apt.date), Local: \(formatter.string(from: apt.date))")
            }

            var generatedSlots: [SlotEntity] = []

            var calendar = Calendar.current
            calendar.timeZone = TimeZone.current
            
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
            
            let startHour = 8
            let endHour = 18
            
            let now = Date()
            let isToday = calendar.isDateInToday(selectedDate)
            let isPastDay = selectedDate < calendar.startOfDay(for: now)

            for hour in startHour...endHour {
                var components = dateComponents
                components.hour = hour
                components.minute = 0
                components.second = 0
                components.timeZone = TimeZone.current
                
                guard let date = calendar.date(from: components) else { continue }
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                print("🔍 Slot local: \(formatter.string(from: date))")
                
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
                
                let isPastTime = isToday && date < now
                let finalOccupied = occupied || isPastDay || isPastTime
                
                print("   Estado: \(finalOccupied ? "🔴 OCUPADO" : "🟢 DISPONIBLE")")

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

    func confirmSelectedSlot(userId: String) async -> Bool {
        guard let selected = selectedSlot else { return false }

        isLoading = true
        errorMessage = nil

        do {
            let _ = try await createAppointmentUC.execute(
                userId: userId,
                appointmentId: currentAppointmentId,
                dateHour: selected
            )

            print("✅ Cita confirmada exitosamente")
            
            lastConfirmedSlot = selected

            selectedSlot = nil
            
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
    
    func generateWeekDays(from start: Date) -> [Date] {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(
            from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: start)
        )!

        let allDays = (0..<7).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: startOfWeek)
        }
        
        return allDays.filter { date in
            let weekday = calendar.component(.weekday, from: date)
            return weekday >= 2 && weekday <= 6
        }
    }
    
    func monthTitle() -> String {
        let name = DateFormats.monthTitle.string(from: selectedDate)
        return name.prefix(1).uppercased() + name.dropFirst()
    }
    
    func goNextWeek() {
        if let newDate = calendar.date(byAdding: .day, value: 7, to: selectedDate) {
            select(date: newDate)
        }
    }

    func goPrevWeek() {
        if let newDate = calendar.date(byAdding: .day, value: -7, to: selectedDate) {
            select(date: newDate)
        }
    }
    
    func select(date: Date) {
        let calendar = Calendar.current
        self.selectedDate = calendar.startOfDay(for: date)
        self.selectedSlot = nil
        
        Task { await loadSlots() }
    }
}

extension Date {
    func convertToLocal() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return self.addingTimeInterval(seconds)
    }
}
