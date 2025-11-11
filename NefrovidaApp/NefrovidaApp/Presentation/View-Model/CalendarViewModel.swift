import Foundation
import Combine

@MainActor
final class AgendaViewModel: ObservableObject {
    @Published var selectedDate: Date
    @Published private(set) var appointments: [Appointment] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?


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
        return name.prefix(1).uppercased() + name.dropFirst()
    }

    func currentWeekDays() -> [Date] {
        var startOfWeek: Date = selectedDate
        let comps = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate)
        startOfWeek = calendar.date(from: comps) ?? selectedDate
        let weekday = calendar.component(.weekday, from: startOfWeek)
        let shift = (weekday == 1) ? 1 : 0
        startOfWeek = calendar.date(byAdding: .day, value: shift, to: startOfWeek) ?? startOfWeek
        return (0..<5).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }

    private func loadIfNeeded(for date: Date) async {
        errorMessage = nil
        let key = DateFormats.apiDay.string(from: date)
        await fetch(forKey: key)
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


    private func fetch(forKey key: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            let list = try await getAppointmentsUC.execute(date: key)
            self.appointments = list
        } catch {
            self.errorMessage = "No se pudieron cargar las citas."
        }
    }
}
