//
//  RescheduleAppointmentView.swift
//  NefrovidaApp
//
//  Created on 02/12/25.
//

import SwiftUI

struct RescheduleAppointmentView: View {
    let appointmentId: Int
    let userId: String
    let appointmentToCancel: Appointment
    
    var body: some View {
        if appointmentToCancel.appointmentType.uppercased() == "ANÁLISIS" {
            RescheduleAnalysisContent(
                appointmentId: appointmentId,
                userId: userId,
                appointmentToCancel: appointmentToCancel
            )
        } else {
            RescheduleAppointmentContent(
                appointmentId: appointmentId,
                userId: userId,
                appointmentToCancel: appointmentToCancel
            )
        }
    }
}

// MARK: - Reschedule Regular Appointment
struct RescheduleAppointmentContent: View {
    let appointmentId: Int
    let userId: String
    let appointmentToCancel: Appointment
    
    @StateObject private var vm: appointmentViewModel
    @StateObject private var cancelVM: AgendaViewModel
    
    @State private var showSuccessAlert = false
    @Environment(\.dismiss) var dismiss
    
    init(appointmentId: Int, userId: String, appointmentToCancel: Appointment) {
        self.appointmentId = appointmentId
        self.userId = userId
        self.appointmentToCancel = appointmentToCancel
        
        // Initialize appointment booking VM
        let repo = AppointmentRepositoryD()
        let getUC = GetAppointmentsUseCase(repository: repo)
        let createUC = CreateAppointmentUseCase(repository: repo)
        _vm = StateObject(wrappedValue: appointmentViewModel(
            getAppointmentsUC: getUC,
            createAppointmentUC: createUC,
            appointmentId: appointmentId
        ))
        
        // Initialize cancellation VM
        let calendarRepo = RemoteAppointmentRepository()
        let calendarUC = GetAppointmentsForDayUseCase(repository: calendarRepo)
        _cancelVM = StateObject(wrappedValue: AgendaViewModel(
            getAppointmentsUC: calendarUC,
            idUser: userId
        ))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            UpBar()
            
            Spacer()
            
            HStack(spacing: 0) {
                Text(vm.monthYearTitle())
                    .font(.title).fontWeight(.bold)
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
                            let cancelled = await cancelVM.cancelSpecificAppointment(appointmentToCancel)
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
        }
        .onAppear {
            Task { await vm.loadSlots() }
        }
        .alert("¡Cita Reagendada!", isPresented: $showSuccessAlert) {
            Button("Aceptar", role: .cancel) { 
                dismiss()
            }
        } message: {
            if let confirmed = vm.lastConfirmedSlot {
                Text("Tu cita anterior ha sido cancelada y la nueva ha sido solicitada para el \(formatFull(date: confirmed))")
            } else {
                Text("Tu cita ha sido reagendada exitosamente")
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

// MARK: - Reschedule Analysis
struct RescheduleAnalysisContent: View {
    let appointmentId: Int
    let userId: String
    let appointmentToCancel: Appointment
    
    @StateObject private var vm: analysisViewModel
    @StateObject private var cancelVM: AgendaViewModel
    
    @State private var showSuccessAlert = false
    @Environment(\.dismiss) var dismiss
    
    init(appointmentId: Int, userId: String, appointmentToCancel: Appointment) {
        self.appointmentId = appointmentId
        self.userId = userId
        self.appointmentToCancel = appointmentToCancel
        
        // Initialize analysis booking VM
        let repo = AnalysisRepositoryD()
        let getUC = getAnalysisUseCase(repository: repo)
        let createUC = CreateAnalysisUseCase(repository: repo)
        _vm = StateObject(wrappedValue: analysisViewModel(
            getAnalysisUC: getUC,
            createAnalysisUC: createUC,
            analysisId: appointmentId
        ))
        
        // Initialize cancellation VM
        let calendarRepo = RemoteAppointmentRepository()
        let calendarUC = GetAppointmentsForDayUseCase(repository: calendarRepo)
        _cancelVM = StateObject(wrappedValue: AgendaViewModel(
            getAppointmentsUC: calendarUC,
            idUser: userId
        ))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            UpBar()
            
            Spacer()
            
            HStack(spacing: 0) {
                Text(vm.monthYearTitle())
                    .font(.title).fontWeight(.bold)
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
                        let success = await vm.confirmSelectedSlot(
                            userId: userId, 
                            place: appointmentToCancel.place ?? "Laboratorio"
                        )
                        if success {
                            let cancelled = await cancelVM.cancelSpecificAppointment(appointmentToCancel)
                            showSuccessAlert = true
                        }
                    }
                }) {
                    Text("Confirmar análisis")
                        .frame(maxWidth: .infinity)
                }
                .disabled(vm.selectedSlot == nil || vm.isLoading)
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)
            }
            .padding(.bottom)
        }
        .onAppear {
            Task { await vm.loadSlots() }
        }
        .alert("¡Análisis Reagendado!", isPresented: $showSuccessAlert) {
            Button("Aceptar", role: .cancel) { 
                dismiss()
            }
        } message: {
            if let confirmed = vm.lastConfirmedSlot {
                Text("Tu análisis anterior ha sido cancelado y el nuevo ha sido solicitado para el \(formatFull(date: confirmed))")
            } else {
                Text("Tu análisis ha sido reagendado exitosamente")
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
