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
            
            // from 7:30 to 9:00, every 10 minutes
            let startHour = 7
            let startMinute = 30
            let endHour = 9
            let endMinute = 0
            
            let now = Date()
            let isToday = calendar.isDateInToday(selectedDate)
            let isPastDay = selectedDate < calendar.startOfDay(for: now)
            
            guard
                let startDate = calendar.date(from: DateComponents(
                    timeZone: TimeZone.current,
                    year: dateComponents.year,
                    month: dateComponents.month,
                    day: dateComponents.day,
                    hour: startHour,
                    minute: startMinute,
                    second: 0
                )),
                let endDateLimit = calendar.date(from: DateComponents(
                    timeZone: TimeZone.current,
                    year: dateComponents.year,
                    month: dateComponents.month,
                    day: dateComponents.day,
                    hour: endHour,
                    minute: endMinute,
                    second: 0
                ))
            else {
                print("No se pudieron construir startDate/endDateLimit para análisis")
                self.slots = []
                isLoading = false
                return
            }
            
            var current = startDate
            while current <= endDateLimit {
                let date = current
                
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
                    
                    if isMatch && analysis.status == "CANCELED" {
                        return false
                    }
                    if isMatch {
                        print("   OCUPADO - Coincide con análisis ID: \(analysis.id)")
                    }
                    
                    return isMatch
                }
                
                let isPastTime = isToday && date < now
                let finalOccupied = occupied || isPastDay || isPastTime
                
                print("   Estado: \(finalOccupied ? " OCUPADO" : " DISPONIBLE")")
                
                generatedSlots.append(
                    AnalysisSlotEntity(date: date, isOccupied: finalOccupied)
                )
                
                // sumar 10 minutos
                guard let next = calendar.date(byAdding: .minute, value: 10, to: current) else {
                    break
                }
                current = next
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
