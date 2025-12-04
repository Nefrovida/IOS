import SwiftUI

struct CalendarView: View {
    var idUser: String
    var fromRiskForm: Bool = false   
    
    @StateObject private var vm: AgendaViewModel
    
    @State private var showDetails = false
    @State private var showRescheduleSheet = false
    @State private var showCancelAlert = false
    @State private var selectedAppointment: Appointment?
    
    @State private var showSuccessMessage = false
    @State private var successMessageText = ""
    
    @State private var goHome = false
    
    @Environment(\.dismiss) var dismiss
    
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
                
                // ---------- CALENDARIO NORMAL ----------
                VStack(spacing: 0) {
                    
                    Spacer()
                    
                    Text(vm.monthYearTitle())
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.vertical)
                    
                    Spacer()
                    
                    WeekStrip(
                        days: vm.currentWeekDays(),
                        selected: vm.selectedDate,
                        onSelect: vm.select
                    )
                    .simultaneousGesture(
                        DragGesture().onEnded { value in
                            if value.translation.width < -40 { vm.goNextWeek() }
                            if value.translation.width > 40 { vm.goPrevWeek() }
                        }
                    )
                    
                    Spacer()
                    
                    ScrollView {
                        if vm.isLoading {
                            ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else if vm.appointments.isEmpty {
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
                
                // ---------- POPUP ----------
                if showDetails, let appointment = selectedAppointment {
                    Color.black.opacity(0.4).ignoresSafeArea()
                        .onTapGesture { showDetails = false }
                    
                    AppointmentPopUp(
                        appointment: appointment,
                        onCancel: { showCancelAlert = true },
                        onReschedule: {
                            showDetails = false
                            showRescheduleSheet = true
                        },
                        onClose: { showDetails = false }
                    )
                }
            }
            
            .navigationBarBackButtonHidden(fromRiskForm)
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Regresar") {
                        if fromRiskForm {
                            goHome = true
                        } else {
                            dismiss()
                        }
                    }
                }
            }
            
            .navigationDestination(isPresented: $goHome) {
                HomeView()
            }
            
            .onAppear { vm.onAppear() }
        }
    }
}
