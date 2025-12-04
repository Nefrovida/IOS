import SwiftUI

struct CalendarView: View {
    var idUser: String
    var fromRiskForm: Bool = false   // 👈 NUEVO, detecta si viene del formulario

    @StateObject private var vm: AgendaViewModel
    
    @State private var showDetails = false
    @State private var showRescheduleSheet = false
    @State private var showCancelAlert = false
    @State private var selectedAppointment: Appointment?
    
    @State private var showSuccessMessage = false
    @State private var successMessageText = ""

    @Environment(\.dismiss) var dismiss  // 👈 Para cerrar normal

    init(idUser: String, fromRiskForm: Bool = false) {
        self.idUser = idUser
        self.fromRiskForm = fromRiskForm

        let repo = RemoteAppointmentRepository()
        let uc = GetAppointmentsForDayUseCase(repository: repo)
        _vm = StateObject(wrappedValue: AgendaViewModel(getAppointmentsUC: uc, idUser: idUser))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    
                    // ----------------------------------------------------
                    //                     HEADER
                    // ----------------------------------------------------
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Text(vm.monthYearTitle())
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // ----------------------------------------------------
                    //               WEEK STRIP + SWIPE
                    // ----------------------------------------------------
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
                    
                    // ----------------------------------------------------
                    //          MESSAGES SUCCESS / ERROR
                    // ----------------------------------------------------
                    if showSuccessMessage {
                        SuccessMessage(
                            message: successMessageText,
                            onDismiss: {
                                withAnimation {
                                    showSuccessMessage = false
                                }
                            }
                        )
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    if let err = vm.errorMessage {
                        ErrorMessage(message: err, onDismiss: { })
                            .padding(.horizontal)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    Spacer()
                    
                    // ----------------------------------------------------
                    //               LIST OF APPOINTMENTS
                    // ----------------------------------------------------
                    if vm.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                    } else if vm.errorMessage != nil {
                        VStack(spacing: 10) {
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
                                        selectedAppointment = appt
                                        showDetails = true
                                    }
                                )
                                .padding(.top, 12)
                            }
                        }
                    }
                }
                
                // ----------------------------------------------------
                //                     POPUP DETAIL
                // ----------------------------------------------------
                if showDetails, let appointment = selectedAppointment {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture { showDetails = false }
                    
                    AppointmentPopUp(
                        appointment: appointment,
                        onCancel: {
                            showCancelAlert = true
                        },
                        onReschedule: {
                            showDetails = false
                            showRescheduleSheet = true
                        },
                        onClose: {
                            showDetails = false
                        }
                    )
                    .transition(.scale.combined(with: .opacity))
                }
            }
            // ------------------------------------------------------------
            // ANIMACIONES
            // ------------------------------------------------------------
            .animation(.spring(response: 0.3), value: showDetails)
            
            // ------------------------------------------------------------
            //   ALERT CANCELAR CITA
            // ------------------------------------------------------------
            .alert("Cancelar Cita", isPresented: $showCancelAlert) {
                Button("Cancelar Cita", role: .destructive) {
                    Task {
                        if let appt = selectedAppointment {
                            vm.SelectedAppointment = appt
                            let ok = await vm.cancelApp()
                            if ok {
                                showDetails = false
                                selectedAppointment = nil
                                vm.select(date: vm.selectedDate)
                                successMessageText = "Cita cancelada correctamente"
                                withAnimation { showSuccessMessage = true }
                            }
                        }
                    }
                }
                Button("No", role: .cancel) {}
            } message: {
                Text("¿Estás seguro que deseas cancelar esta cita?")
            }
            
            // ------------------------------------------------------------
            //   SHEET REAGENDAR
            // ------------------------------------------------------------
            .sheet(isPresented: $showRescheduleSheet) {
                if let appointment = selectedAppointment {
                    NavigationView {
                        Group {
                            if appointment.appointmentType.uppercased() == "ANÁLISIS" {
                                analysisView(
                                    analysisId: appointment.appointmentId,
                                    userId: idUser,
                                    onConfirm: {
                                        Task {
                                            await cancelPreviousAppointment(appointment)
                                            successMessageText = "Análisis reagendado correctamente"
                                            withAnimation { showSuccessMessage = true }
                                            vm.select(date: vm.selectedDate)
                                        }
                                    }
                                )
                            } else {
                                appointmentView(
                                    appointmentId: appointment.appointmentId,
                                    userId: idUser,
                                    onConfirm: {
                                        Task {
                                            await cancelPreviousAppointment(appointment)
                                            successMessageText = "Cita reagendada correctamente"
                                            withAnimation { showSuccessMessage = true }
                                            vm.select(date: vm.selectedDate)
                                        }
                                    }
                                )
                            }
                        }
                        .navigationTitle("Reagendar Horario")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Cerrar") {
                                    showRescheduleSheet = false
                                }
                            }
                        }
                    }
                    .presentationDetents([.large])
                }
            }
            
            // ------------------------------------------------------------
            // ON APPEAR LOAD
            // ------------------------------------------------------------
            .onAppear { vm.onAppear() }
            
            // ------------------------------------------------------------
            // TOOLBAR: BACK BUTTON CONTROLADO
            // ------------------------------------------------------------
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Regresar") {
                        if fromRiskForm {
                            // 👈 SI VIENE DEL FORMULARIO, REGRESA AL HOME (ContentView)
                            UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true)
                        } else {
                            dismiss() // 👈 SOLO cierra esta vista
                        }
                    }
                }
            }
        }
    }
    
    // Eliminación de cita anterior al reagendar
    private func cancelPreviousAppointment(_ appointment: Appointment) async {
        let calendarRepo = RemoteAppointmentRepository()
        let calendarUC = GetAppointmentsForDayUseCase(repository: calendarRepo)
        let cancelVM = AgendaViewModel(getAppointmentsUC: calendarUC, idUser: idUser)
        _ = await cancelVM.cancelSpecificAppointment(appointment)
    }
}

// Preview
#Preview {
    CalendarView(idUser: "4b74425f-6c7a-4cf6-ac19-18372ac9854a", fromRiskForm: true)
}
