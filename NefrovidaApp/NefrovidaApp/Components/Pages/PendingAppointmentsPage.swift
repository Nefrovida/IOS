//
//  PendingAppointmentsPage.swift
//  NefrovidaApp
//
//  Created by Iván FV on 06/11/25.
//

import SwiftUI

struct PendingAppointmentsPage: View {
    @StateObject var vm = PendingAppointmentsVM()

    var body: some View {
        NavigationStack {
            List(vm.items) { appt in
                NavigationLink {
                    AppointmentDetailPage(appointment: appt)
                } label: {
                    HStack {
                        Image(systemName: appt.status == .pendiente ? "clock" : "checkmark.seal")
                        VStack(alignment: .leading) {
                            Text(appt.patientName).font(.headline)
                            Text(appt.analysisName).font(.subheadline)
                        }
                        Spacer()
                        Text(appt.status == .pendiente ? "Pendiente" : "Entregado")
                            .foregroundStyle(appt.status == .pendiente ? .yellow : .green)
                    }
                }
            }
            .navigationTitle("Resultados pendientes")
            .task { await vm.load() }
            .overlay {
                if vm.loading { ProgressView() }
            }
            .alert("Error", isPresented: .constant(vm.error != nil), actions: {}, message: { Text(vm.error ?? "") })
        }
    }
}
