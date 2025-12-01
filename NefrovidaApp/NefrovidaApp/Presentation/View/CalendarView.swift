import SwiftUI
// Agenda that show the user's scheduled appointments for each day and allows weekly navigation.
struct CalendarView: View {
    // ViewModel that handles the state, data, and logic of the agenda.
    var idUser : String
    @StateObject private var vm: AgendaViewModel
    
    // Initializes the agenda screen by injecting dependencies into the ViewModel.
    // Parameter idUser: The unique identifier of the authenticated user.
    init(idUser: String) {
        self.idUser = idUser
        
        let appointmentRepo = RemoteAppointmentRepository()
        let cancelApptRepo = RemoteCancelAppointmentRepository()
        let cancelAnalysisRepo = RemoteCancelAnalysisRepository()

        let getUC = GetAppointmentsForDayUseCase(repository: appointmentRepo)
        let cancelUC = CancelAppointmentUseCase(repository: cancelApptRepo)
        let cancelAnalysisUC = CancelAnalysisUseCase(repository: cancelAnalysisRepo)

        _vm = StateObject(wrappedValue:
            AgendaViewModel(
                getAppointmentsUC: getUC,
                cancelAppointmentUC: cancelUC,
                cancelAnalysisUC: cancelAnalysisUC,
                idUser: idUser
            )
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Top bar (title, user info, etc.)
            UpBar()
            
            Spacer()
            
            // Header section with tabs and current month title.
            HStack(spacing: 12) {
                // Displays the current month title (e.g., “November”)
                Text(vm.monthYearTitle())
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Week selector strip (allows user to pick a specific day).
            WeekStrip(
                days: vm.currentWeekDays(),
                selected: vm.selectedDate,
                onSelect: vm.select
            )
            // Enables swipe gesture for week navigation (left/right).
            .simultaneousGesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width < -40 { vm.goNextWeek() }  // Swipe left
                        if value.translation.width > 40 { vm.goPrevWeek() }  // Swipe right
                    }
            )
            
            // Displays loading indicator, error message, or appointments list depending on state.
            if vm.isLoading {
                // Shows a loading spinner while fetching data.
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let err = vm.errorMessage {
                // Shows an error message with retry option.
                VStack(spacing: 10) {
                    Text(err)
                        .foregroundStyle(.red)
                    Button("Reintentar") {
                        vm.select(date: vm.selectedDate)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // Scrollable list of appointments.
                ScrollView {
                    if vm.appointments.isEmpty {
                        // Placeholder message when no appointments exist.
                        Text("No hay citas para este día.")
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, minHeight: 240)
                    } else {
                        // List of appointments for the selected day.
                        AgendaList(appointments: vm.appointments)
                            .padding(.top, 12)
                    }
                }
            }
            
        }
        // Loads appointments when the view appears on screen.
        .onAppear { vm.onAppear() }
        .onReceive(NotificationCenter.default.publisher(for: .cancelAppointmentRequest)) { notif in
            if let appt = notif.object as? Appointment {
                vm.cancel(appt: appt)
            }
        }
    }
}
