//
//  AnalysisAppointmentViewModel.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 25/11/25.
//

import Foundation
import SwiftUI
import Combine

// Represents a single analysis slot with a unique ID.
struct AnalysisSlotEntity: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let isOccupied: Bool
}

@MainActor
final class analysisViewModel: ObservableObject {
    @Published var selectedDate: Date
    @Published var slots: [AnalysisSlotEntity] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedSlot: Date?
    @Published var lastConfirmedSlot: Date?
    
    private let calendar = Calendar(identifier: .gregorian)
    private var analysisId: Int
    
    private let getAnalysisUC: getAnalysisUseCase
    private let createAnalysisUC: CreateAnalysisUseCase
    private var currentAnalysisId: Int = 0
    
    init(
        getAnalysisUC: getAnalysisUseCase,
        createAnalysisUC: CreateAnalysisUseCase,
        analysisId: Int
    ) {
        self.getAnalysisUC = getAnalysisUC
        self.createAnalysisUC = createAnalysisUC
        self.analysisId = analysisId
        
        let calendar = Calendar.current
        self.selectedDate = calendar.startOfDay(for: Date())
    }
    
    // Loads available and occupied analysis slots for the selected date
    func loadSlots() async {
        isLoading = true
        errorMessage = nil
        self.currentAnalysisId = self.analysisId
        
        do {
            let takenAnalysis = try await getAnalysisUC.execute(
                date: selectedDate,
                analysisId: self.analysisId
            )
            
            print("Análisis ocupados recibidos: \(takenAnalysis.count)")
            print("Zona horaria local: \(TimeZone.current.identifier)")
            
            for analysis in takenAnalysis {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                print("   - ID: \(analysis.id), Fecha UTC: \(analysis.date), Local: \(formatter.string(from: analysis.date))")
            }
            
            var generatedSlots: [AnalysisSlotEntity] = []
            var calendar = Calendar.current
            calendar.timeZone = TimeZone.current
            
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
            
            // Time range for analysis (8 AM - 5 PM)
            let startHour = 8
            let endHour = 17
            
            let now = Date()
            let isToday = calendar.isDateInToday(selectedDate)
            let isPastDay = selectedDate < calendar.startOfDay(for: now)
            
            // Generate 10-minute interval slots
            for hour in startHour...endHour {
                for minute in stride(from: 0, to: 60, by: 10) {
                    var components = dateComponents
                    components.hour = hour
                    components.minute = minute
                    components.second = 0
                    components.timeZone = TimeZone.current
                    
                    if hour == endHour && minute > 0 {
                        continue
                    }
                    
                    guard let date = calendar.date(from: components) else { continue }
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                    print("🔍 Slot local: \(formatter.string(from: date))")
                    
                    let occupied = takenAnalysis.contains { analysis in
                        let slotComps = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                        let analysisComps = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: analysis.date)
                        
                        let isMatch = slotComps.year == analysisComps.year &&
                        slotComps.month == analysisComps.month &&
                        slotComps.day == analysisComps.day &&
                        slotComps.hour == analysisComps.hour &&
                        slotComps.minute == analysisComps.minute
                        
                        if isMatch {
                            print("   ✅ OCUPADO - Coincide con análisis ID: \(analysis.id)")
                        }
                        
                        return isMatch
                    }
                    
                    let isPastTime = isToday && date < now
                    let finalOccupied = occupied || isPastDay || isPastTime
                    
                    print("   Estado: \(finalOccupied ? "🔴 OCUPADO" : "🟢 DISPONIBLE")")
                    
                    generatedSlots.append(
                        AnalysisSlotEntity(date: date, isOccupied: finalOccupied)
                    )
                }
            }
            
            self.slots = generatedSlots
            print("Total de slots generados: \(generatedSlots.count)")
            
        } catch {
            print("Error en loadSlots: \(error.localizedDescription)")
            errorMessage = "Error cargando análisis: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // Confirms the currently selected slot
    func confirmSelectedSlot(userId: String, place: String? = nil) async -> Bool {
        guard let selected = selectedSlot else { return false }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let _ = try await createAnalysisUC.execute(
                userId: userId,
                analysisId: currentAnalysisId,
                analysisDate: selected,
                place: place
            )
            
            print("✅ Análisis confirmado exitosamente")
            
            lastConfirmedSlot = selected
            selectedSlot = nil
            
            await loadSlots()
            
            isLoading = false
            return true
            
        } catch {
            print("ERROR EN confirmSelectedSlot:", error.localizedDescription)
            errorMessage = "Error al confirmar el análisis: \(error.localizedDescription)"
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
    
    func monthYearTitle() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_MX")
        formatter.dateFormat = "LLLL yyyy"
        
        let raw = formatter.string(from: selectedDate)
        return raw.prefix(1).capitalized + raw.dropFirst()
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
