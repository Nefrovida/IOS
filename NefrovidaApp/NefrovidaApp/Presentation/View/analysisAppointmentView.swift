//
//  AnalysisAppointmentView.swift
//  NefrovidaApp
//
//  Created by Emilio Santiago López Quiñonez on 25/11/25.
//

import SwiftUI

struct analysisView: View {
    let analysisId: Int
    let userId: String
    
    @StateObject private var vm: analysisViewModel
    @State private var showSuccessAlert = false
    
    init(analysisId: Int, userId: String) {
        self.analysisId = analysisId
        self.userId = userId
        
        let repo = AnalysisRepositoryD()
        let getUC = getAnalysisUseCase(repository: repo)
        let createUC = CreateAnalysisUseCase(repository: repo)
        
        _vm = StateObject(wrappedValue: analysisViewModel(
            getAnalysisUC: getUC,
            createAnalysisUC: createUC,
            analysisId: analysisId
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
                        let success = await vm.confirmSelectedSlot(userId: userId, place: "Laboratorio")
                        if success {
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
        .alert("¡Análisis Solicitado!", isPresented: $showSuccessAlert) {
            Button("Aceptar", role: .cancel) { }
        } message: {
            if let confirmed = vm.lastConfirmedSlot {
                Text("Tu análisis ha sido solicitado para el \(formatFull(date: confirmed))")
            } else {
                Text("Tu análisis ha sido agendado exitosamente")
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
    analysisView(analysisId: 1, userId: "12345-ABCDE")
}
