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
    
    // ViewModel instance that manages appointment logic and state
    @StateObject private var vm: appointmentViewModel
    // Controls the display of the success alert
    @State private var showSuccessAlert = false

    init(appointmentId: Int, userId: String) {
        self.appointmentId = appointmentId
        self.userId = userId
        // Creates repository and use cases, injecting dependencies manually
        let repo = AppointmentRepositoryD()
        let getUC = GetAppointmentsUseCase(repository: repo)
        let createUC = CreateAppointmentUseCase(repository: repo)
        // Initializes the ViewModel with the required use cases
        _vm = StateObject(wrappedValue: appointmentViewModel(
            getAppointmentsUC: getUC,
            createAppointmentUC: createUC,
            appointmentId: appointmentId
        ))
    }

    var body: some View {
        VStack(spacing: 0) {
            // Custom top bar UI component
            UpBar()
            
            Spacer()
            
            // Top tab-like buttons (Citas / Solicitudes)
            HStack(spacing: 12) {
                ChipTab(title: "Citas", isSelected: true) { print("Citas") }
                ChipTab(title: "Solicitudes", isSelected: false) { print("Solicitudes") }
                Spacer()
                // Displays current month title based on selected date
                Text(vm.monthTitle())
                    .font(.title3).fontWeight(.bold)
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Week strip component that shows the 7-day row for selection
            WeekStrip(
                days: vm.generateWeekDays(from: vm.selectedDate),
                selected: vm.selectedDate,
                onSelect: { date in
                    // Updates selected date and reloads available slots
                    vm.selectedDate = date
                    Task { await vm.loadSlots() }
                }
            )
            // Allows horizontal swipe gesture (previous or next week)
            .simultaneousGesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width < -40 { vm.goNextWeek() }
                        if value.translation.width > 40 { vm.goPrevWeek() }
                    }
            )

            Divider()
            
            // Loading state
            if vm.isLoading {
                
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            // Error state showing retry option
            } else if let err = vm.errorMessage {
                
                VStack(spacing: 10) {
                    Text(err).foregroundColor(.red)
                    Button("Reintentar") { Task { await vm.loadSlots() } }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            // Normal display state: showing available appointment slots
            } else {
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(vm.slots, id: \.date) { slot in
                            
                            // Custom UI component for selectable time slot
                            timeSelectable(
                                date: slot.date,
                                state: slot.isOccupied ? .occupied : .available,
                                isSelected: vm.selectedSlot == slot.date
                            ) {
                                // Select or deselect a slot only if available
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
            
            // Bottom section: selected time + confirm button
            VStack(spacing: 12) {
                
                // Displays selected time or a placeholder
                if let selected = vm.selectedSlot {
                    Text("Seleccionado: \(format(date: selected))")
                } else {
                    Text("Selecciona un horario")
                        .foregroundColor(.secondary)
                }

                // Confirm appointment button
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
                // Disabled if no slot selected or loading
                .disabled(vm.selectedSlot == nil || vm.isLoading)
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)
            }
            .padding(.bottom)

            // Custom bottom bar UI component
            BottomBar(idUser:"21212")
        }
        // Loads slots when view appears
        .onAppear {
            Task { await vm.loadSlots() }
        }
        
        .navigationTitle("Agendar cita")
        // Success appointment alert
        .alert("¡Cita Solicitada!", isPresented: $showSuccessAlert) {
            Button("Aceptar", role: .cancel) { }
        } message: {
            if let confirmed = vm.lastConfirmedSlot {
                Text("Tu cita ha sido solicitada para el \(formatFull(date: confirmed))")
            } else {
                Text("Tu cita ha sido agendada exitosamente")
            }
        }
    }

    // Formats time only
    private func format(date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "hh:mm a"
        return f.string(from: date)
    }
    
    // Formats complete descriptive date in Spanish (e.g., “Lunes 21 de Octubre a las 08:00 AM”)
    private func formatFull(date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "EEEE d 'de' MMMM 'a las' hh:mm a"
        f.locale = Locale(identifier: "es_MX")
        return f.string(from: date)
    }
}

#Preview {
    // Preview configuration for SwiftUI canvas
    appointmentView(appointmentId: 1, userId: "12345-ABCDE")
}
