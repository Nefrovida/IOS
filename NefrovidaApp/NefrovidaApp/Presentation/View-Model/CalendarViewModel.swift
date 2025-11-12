import Foundation
import Combine

// ViewModel responsible for managing the agenda (calendar) logic and state.
@MainActor
final class AgendaViewModel: ObservableObject {

    // The currently selected date in the agenda.
    @Published var selectedDate: Date
    
    // List of appointments for the selected day.
    @Published private(set) var appointments: [Appointment] = []
    
    // Indicates whether data is currently being loaded.
    @Published private(set) var isLoading = false
    
    // Optional error message displayed when a data request fails.
    @Published private(set) var errorMessage: String?

    // Use case responsible for retrieving appointments from the repository layer.
    private let getAppointmentsUC: GetAppointmentsForDayUseCase
    
    // Calendar instance used for date calculations (e.g., weeks and months).
    private let calendar = Calendar(identifier: .gregorian)
    
    // The ID of the currently authenticated user.
    let idUser: String

    // Creates a new instance of the CalendarViewModel.
    // Parameters: selectedDate: The initial date shown in the agenda (defaults to today).
    // getAppointmentsUC: The use case responsible for retrieving appointments.
    // idUser: The authenticated user's identifier.
    init(
        selectedDate: Date = Date(),
        getAppointmentsUC: GetAppointmentsForDayUseCase,
        idUser: String
    ) {
        self.selectedDate = selectedDate
        self.getAppointmentsUC = getAppointmentsUC
        self.idUser = idUser
    }

    // Called when the view appears for the first time.
    // Triggers the initial loading of appointments for the current date.
    func onAppear() {
        Task { await loadIfNeeded(for: selectedDate) }
    }

    // Updates the selected date and reloads the corresponding appointments.
    // Parameter date: The new date selected by the user.
    func select(date: Date) {
        selectedDate = date
        Task { await loadIfNeeded(for: date) }
    }

    // Loads appointments for a specific date if necessary.
    // Parameter date: The target date to fetch appointments for.
    private func loadIfNeeded(for date: Date) async {
        errorMessage = nil
        let key = DateFormats.apiDay.string(from: date)
        await fetch(forKey: key)
    }

    //Performs the asynchronous call to fetch appointments from the use case.
    //Parameter key: The date key (formatted as `"yyyy-MM-dd"`) used for the API query.
    // idUser: the id of the user when he audenticate.
    private func fetch(forKey key: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            // Executes the use case with the date and user ID.
            let list = try await getAppointmentsUC.execute(date: key, idUser: idUser)
            self.appointments = list
        } catch {
            // Handles any network or decoding errors.
            self.errorMessage = "Error al obtener citas."
        }
    }

    // Moves the selected date one week forward.
    func goNextWeek() {
        if let newDate = calendar.date(byAdding: .day, value: 7, to: selectedDate) {
            select(date: newDate)
        }
    }

    //Moves the selected date one week backward.
    func goPrevWeek() {
        if let newDate = calendar.date(byAdding: .day, value: -7, to: selectedDate) {
            select(date: newDate)
        }
    }

    // Returns the current month name formatted for display.
    func monthTitle() -> String {
        let name = DateFormats.monthTitle.string(from: selectedDate)
        return name.prefix(1).uppercased() + name.dropFirst()
    }

    //Returns the list of days for the current week.
    // The week starts from the first weekday (e.g., Monday) and includes five consecutive days.
    func currentWeekDays() -> [Date] {
        var startOfWeek: Date = selectedDate
        let comps = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate)
        startOfWeek = calendar.date(from: comps) ?? selectedDate
        let weekday = calendar.component(.weekday, from: startOfWeek)
        let shift = (weekday == 1) ? 1 : 0
        startOfWeek = calendar.date(byAdding: .day, value: shift, to: startOfWeek) ?? startOfWeek
        return (0..<5).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }
}
