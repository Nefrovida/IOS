//
//  CalendarViewModel.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 08/11/25.
//

// Presentation/View-Model/AgendaViewModel.swift
import Foundation
import Combine

@MainActor
final class AgendaViewModel: ObservableObject {
    // Entrada / estado de UI
    @Published var selectedDate: Date
    @Published private(set) var appointments: [Appointment] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    // Cache RAM por día "yyyy-MM-dd" -> citas
    private var cache: [String: [Appointment]] = [:]

    // Dependencias Clean
    private let getAppointmentsUC: GetAppointmentsForDayUseCase
    private let calendar = Calendar(identifier: .gregorian)

    init(selectedDate: Date = Date(),
         getAppointmentsUC: GetAppointmentsForDayUseCase) {
        self.selectedDate = selectedDate
        self.getAppointmentsUC = getAppointmentsUC
    }

    func onAppear() {
        Task { await loadIfNeeded(for: selectedDate) }
    }

    func select(date: Date) {
        selectedDate = date
        Task { await loadIfNeeded(for: date) }
    }

    func monthTitle() -> String {
        let name = DateFormats.monthTitle.string(from: selectedDate)
        // Capitalizamos primera letra estilo "Octubre"
        return name.prefix(1).uppercased() + name.dropFirst()
    }

    /// Semana (lun..dom) de la fecha seleccionada
    func currentWeekDays() -> [Date] {
        var startOfWeek: Date = selectedDate
        let comps = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate)
        startOfWeek = calendar.date(from: comps) ?? selectedDate
        // Forzar lunes como inicio
        let weekday = calendar.component(.weekday, from: startOfWeek) // 1=Dom
        let shift = (weekday == 1) ? 1 : 0
        startOfWeek = calendar.date(byAdding: .day, value: shift, to: startOfWeek) ?? startOfWeek
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }

    // MARK: - Private

    private func loadIfNeeded(for date: Date) async {
        errorMessage = nil
        let key = DateFormats.apiDay.string(from: date)
        if let cached = cache[key] {
            self.appointments = cached
            return
        }
        await fetch(forKey: key)
    }

    private func fetch(forKey key: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            let list = try await getAppointmentsUC.execute(date: key)
            cache[key] = list
            self.appointments = list
        } catch {
            self.errorMessage = "No se pudieron cargar las citas."
        }
    }
}
