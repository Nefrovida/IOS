import SwiftUI

struct AgendaScreen: View {
    @StateObject private var vm: AgendaViewModel

    init() {
        let repo = MockAppointmentRepository()
        let uc = GetAppointmentsForDayUseCase(repository: repo)
        _vm = StateObject(wrappedValue: AgendaViewModel(getAppointmentsUC: uc))
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Profile()
                Spacer()
                NefroVidaLogo()
                Spacer()
                Notification()
            }
            .padding()
            .background(.ultraThinMaterial)
            
            Spacer()

            HStack(spacing: 12) {
                ChipTab(title: "Citas", isSelected: true)
                ChipTab(title: "Solicitudes", isSelected: false)
                Spacer()
                Text(vm.monthTitle())
                    .font(.title3).fontWeight(.bold)
            }
            .padding(.horizontal)

            Spacer()

            WeekStrip(days: vm.currentWeekDays(),
                      selected: vm.selectedDate,
                      onSelect: vm.select)
            
            .simultaneousGesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width < -40 { vm.goNextWeek() }
                        if value.translation.width > 40 { vm.goPrevWeek() }
                    }
            )


            if vm.isLoading {
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let err = vm.errorMessage {
                VStack(spacing: 10) {
                    Text(err).foregroundStyle(.red)
                    Button("Reintentar") { vm.select(date: vm.selectedDate) }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    if vm.appointments.isEmpty {
                        Text("No hay citas para este día.")
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, minHeight: 240)
                    } else {
                        AgendaList(appointments: vm.appointments)
                            .padding(.top, 12)
                    }
                }
            }

            BottomBar()

        }
        .onAppear { vm.onAppear() }
    }
}

#Preview {
    AgendaScreen()
}
