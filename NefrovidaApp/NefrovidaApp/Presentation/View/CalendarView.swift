//
//  CalendarView.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 08/11/25.
//

//
//  AgendaScreen.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos Rivera on 08/11/25.
//

// Presentation/View/AgendaScreen.swift
import SwiftUI

struct AgendaScreen: View {
    @StateObject private var vm: AgendaViewModel

    // DI entry (cámbialo a RemoteAppointmentRepository cuando conectes API real)
    init() {
        let repo = MockAppointmentRepository()
        let uc = GetAppointmentsForDayUseCase(repository: repo)
        _vm = StateObject(wrappedValue: AgendaViewModel(getAppointmentsUC: uc))
    }

    var body: some View {
        VStack(spacing: 0) {
            // Top bar simple
            HStack {
                Image(systemName: "person.crop.circle")
                Spacer()
                Text("NEFRO Vida").font(.headline)
                Spacer()
                Image(systemName: "bell")
            }
            .padding()
            .background(.ultraThinMaterial)
            
            Spacer()

            // Tabs (Citas / Solicitudes)
            HStack(spacing: 12) {
                ChipTab(title: "Citas", isSelected: true)
                ChipTab(title: "Solicitudes", isSelected: false)
                Spacer()
                Text(vm.monthTitle())
                    .font(.title3).fontWeight(.bold)
            }
            .padding(.horizontal)

            Spacer()
            // Week strip
            WeekStrip(days: vm.currentWeekDays(),
                      selected: vm.selectedDate,
                      onSelect: vm.select)
            
            .simultaneousGesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width < -30 { vm.goNextWeek() }
                        if value.translation.width > 30 { vm.goPrevWeek() }
                    }
            )


            // Agenda
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

            // Bottom bar (tabs)
            BottomBar()

        }
        .onAppear { vm.onAppear() }
    }
}

#Preview {
    AgendaScreen()
}
