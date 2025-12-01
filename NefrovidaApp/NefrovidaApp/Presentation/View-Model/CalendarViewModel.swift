import Foundation
import SwiftUI
import Combine

@MainActor
final class AgendaViewModel: ObservableObject {

    @Published var selectedDate: Date
    @Published private(set) var appointments: [Appointment] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published var toastMessage: String?

    private let getAppointmentsUC: GetAppointmentsForDayUseCase
    private let cancelAppointmentUC: CancelAppointmentUseCase
    private let cancelAnalysisUC: CancelAnalysisUseCase
    
    private let calendar = Calendar(identifier: .gregorian)
    let idUser: String
    
    init(
        selectedDate: Date = Date(),
        getAppointmentsUC: GetAppointmentsForDayUseCase,
        cancelAppointmentUC: CancelAppointmentUseCase,
        cancelAnalysisUC: CancelAnalysisUseCase,
        idUser: String
    ) {
        self.selectedDate = selectedDate
        self.getAppointmentsUC = getAppointmentsUC
        self.cancelAppointmentUC = cancelAppointmentUC
        self.cancelAnalysisUC = cancelAnalysisUC
        self.idUser = idUser
    }

    func onAppear() {
        Task { await loadIfNeeded(for: selectedDate) }
    }

    func select(date: Date) {
        selectedDate = date
        Task { await loadIfNeeded(for: date) }
    }

    private func loadIfNeeded(for date: Date) async {
        errorMessage = nil
        let key = DateFormats.apiDay.string(from: date)
        await fetch(forKey: key)
    }

    private func fetch(forKey key: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            let list = try await getAppointmentsUC.execute(
                date: key,
                idUser: idUser
            )
            self.appointments = list
        } catch {
            self.errorMessage = "Error al obtener citas."
        }
    }

    // ===================================================
    // MARK: 🔥 Utilidades de UI (antes estaban EN LA VIEW)
    // ===================================================
    
    /// Ejemplo: "Noviembre 2025"
    func monthYearTitle() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_MX")
        formatter.dateFormat = "LLLL yyyy"
        
        let raw = formatter.string(from: selectedDate)
        return raw.prefix(1).capitalized + raw.dropFirst()
    }
    
    /// Retorna los 5 días de la semana de la fecha seleccionada
    func currentWeekDays() -> [Date] {
        var startOfWeek: Date = selectedDate
        
        let comps = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate)
        startOfWeek = calendar.date(from: comps) ?? selectedDate
        
        let weekday = calendar.component(.weekday, from: startOfWeek)
        let shift = (weekday == 1) ? 1 : 0
        startOfWeek = calendar.date(byAdding: .day, value: shift, to: startOfWeek) ?? startOfWeek
        
        return (0..<5).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
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

    // ===================================================
    // MARK: 🟥 Cancelar cita o análisis
    // ===================================================
    func cancel(appt: Appointment) {

        if !appt.canBeCancelled {
            toastMessage = "📆 Debes cancelar mínimo 24 horas antes."
            return
        }

        Task {
            do {
                if appt.appointmentType == "ANÁLISIS" {
                    try await cancelAnalysisUC.execute(id: appt.patientAppointmentId)
                } else {
                    try await cancelAppointmentUC.execute(id: appt.patientAppointmentId)
                }

                toastMessage = "🟢 Cancelación exitosa"
                await loadIfNeeded(for: selectedDate)

            } catch {
                toastMessage = "❌ Error al cancelar"
            }
        }
    }
}
