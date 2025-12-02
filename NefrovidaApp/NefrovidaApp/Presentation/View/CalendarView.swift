import SwiftUI

struct CalendarView: View {
    var idUser : String
    @StateObject private var vm: AgendaViewModel
    
    @State private var showDetails = false
    @State private var navigateToReschedule = false
    @State private var appointmentIdToReschedule: Int?

    init(idUser: String) {
        self.idUser = idUser
        let repo = RemoteAppointmentRepository()
        let uc = GetAppointmentsForDayUseCase(repository: repo)
        _vm = StateObject(wrappedValue: AgendaViewModel(getAppointmentsUC: uc, idUser: idUser))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                UpBar()

            Spacer()

            HStack(spacing: 12) {
                Text(vm.monthYearTitle())
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding(.horizontal)

            Spacer()

            WeekStrip(
                days: vm.currentWeekDays(),
                selected: vm.selectedDate,
                onSelect: vm.select
            )
            .simultaneousGesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width < -40 { vm.goNextWeek() }
                        if value.translation.width > 40 { vm.goPrevWeek() }
                    }
            )

            if vm.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let err = vm.errorMessage {
                VStack(spacing: 10) {
                    Text(err)
                        .foregroundStyle(.red)
                    Button("Reintentar") {
                        vm.select(date: vm.selectedDate)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    if vm.appointments.isEmpty {
                        Text("No hay citas para este día.")
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, minHeight: 240)
                    } else {
                        AgendaList(
                            appointments: vm.appointments,
                            onAppointmentTap: { appt in
                                vm.SelectedAppointment = appt
                                showDetails = true
                            }
                        )
                        .padding(.top, 12)
                    }
                }
            }
        }
        .sheet(isPresented: $showDetails) {
            if let appt = vm.SelectedAppointment {
                AppointmentPopup(
                    appt: appt,
                    onCancel: {
                        Task {
                            let ok = await vm.cancelApp()
                            if ok {
                                showDetails = false
                                vm.select(date: vm.selectedDate) 
                            }
                        }
                    },
                    onClose: {
                        showDetails = false
                    },
                    onReschedule: {
                        Task {
                            let ok = await vm.cancelApp()
                            if ok {
                                appointmentIdToReschedule = appt.appointmentId
                                showDetails = false
                                navigateToReschedule = true
                            }
                        }
                    }
                )
            }
        }
        .navigationDestination(isPresented: $navigateToReschedule) {
            if let appointmentId = appointmentIdToReschedule {
                appointmentView(appointmentId: appointmentId, userId: idUser)
            }
        }
        .onAppear { vm.onAppear() }
        }
    }
}
