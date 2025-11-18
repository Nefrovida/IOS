//
//  appointmentViewModel.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 15/11/25.
//

import SwiftUI

struct appointmentView: View {
    let appointmentId: Int
    let userId: String
    
    @StateObject private var vm: appointmentViewModel
    @State private var showSuccessAlert = false

    init(appointmentId: Int, userId: String) {
        self.appointmentId = appointmentId
        self.userId = userId
        let repo = AppointmentRepositoryD()
        let getUC = GetAppointmentsUseCase(repository: repo)
        let createUC = CreateAppointmentUseCase(repository: repo)
        _vm = StateObject(wrappedValue: appointmentViewModel(
            getAppointmentsUC: getUC,
            createAppointmentUC: createUC,
            appointmentId: appointmentId
        ))
    }

    var body: some View {
        VStack(spacing: 0) {
            UpBar()
            
            Spacer()
            
            HStack(spacing: 12) {
                ChipTab(title: "Citas", isSelected: true) { print("Citas") }
                ChipTab(title: "Solicitudes", isSelected: false) { print("Solicitudes") }
                Spacer()
                Text(vm.monthTitle())
                    .font(.title3).fontWeight(.bold)
            }
            .padding(.horizontal)
            
            Spacer()
            
            WeekStrip(
                days: vm.generateWeekDays(from: vm.selectedDate),
                selected: vm.selectedDate,
                onSelect: { date in
                    vm.selectedDate = date
                    Task { await vm.loadSlots() }
                }
            )
            .simultaneousGesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width < -40 { vm.goNextWeek() }
                        if value.translation.width > 40 { vm.goPrevWeek() }
                    }
            )

            Divider()
            
            if vm.isLoading {
                
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            } else if let err = vm.errorMessage {
                
                VStack(spacing: 10) {
                    Text(err).foregroundColor(.red)
                    Button("Reintentar") { Task { await vm.loadSlots() } }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            } else {
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(vm.slots, id: \.date) { slot in
                            
                            timeSelectable(
                                date: slot.date,
                                state: slot.isOccupied ? .occupied : .available,
                                isSelected: vm.selectedSlot == slot.date
                            ) {
                                if !slot.isOccupied {
                                    vm.selectedSlot = (vm.selectedSlot == slot.date ? nil : slot.date)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 12)
                }
            }

            Spacer()
            
            VStack(spacing: 12) {
                
                if let selected = vm.selectedSlot {
                    Text("Seleccionado: \(format(date: selected))")
                } else {
                    Text("Selecciona un horario")
                        .foregroundColor(.secondary)
                }

                Button(action: {
                    Task {
                        let success = await vm.confirmSelectedSlot(userId: userId)
                        if success {
                            showSuccessAlert = true
                        }
                    }
                }) {
                    Text("Confirmar cita")
                        .frame(maxWidth: .infinity)
                }
                .disabled(vm.selectedSlot == nil || vm.isLoading)
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)
            }
            .padding(.bottom)

            BottomBar()
        }
        .onAppear {
            Task { await vm.loadSlots() }
        }
        .navigationTitle("Agendar cita")
        .alert("¡Cita confirmada!", isPresented: $showSuccessAlert) {
            Button("Aceptar", role: .cancel) { }
        } message: {
            if let confirmed = vm.lastConfirmedSlot {
                Text("Tu cita ha sido agendada para el \(formatFull(date: confirmed))")
            } else {
                Text("Tu cita ha sido agendada exitosamente")
            }
        }
    }

    private func format(date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "hh:mm a"
        return f.string(from: date)
    }
    
    private func formatFull(date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "EEEE d 'de' MMMM 'a las' hh:mm a"
        f.locale = Locale(identifier: "es_MX")
        return f.string(from: date)
    }
}

#Preview {
    appointmentView(appointmentId: 1, userId: "12345-ABCDE")
}
