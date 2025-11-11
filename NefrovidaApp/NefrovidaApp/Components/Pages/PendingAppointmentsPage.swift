//
//  PendingAppointmentsPage.swift
//  NefrovidaApp
//
//  Created by Iván FV on 06/11/25.
//
// Components/Pages/PendingAppointmentsPage.swift

import SwiftUI

struct PendingAppointmentsPage: View {
    @StateObject var vm = PendingAppointmentsVM()

    var body: some View {
        NavigationStack {
            ZStack {
                NV.pageBG.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Encabezado
                        Text("Resultados pendientes")
                            .font(.system(size: 26, weight: .heavy))
                            .foregroundStyle(NV.blue)
                            .padding(.top, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        // Barra de acciones (lupa/filtro) – placeholders
//                        HStack(spacing: 18) {
//                            Spacer()
//                            Image(systemName: "magnifyingglass").font(.title3)
//                            Image(systemName: "line.3.horizontal.decrease.circle").font(.title3)
//                        }
//                        .foregroundStyle(.secondary)

                        // Tarjetas
                        LazyVStack(spacing: 14) {
                            ForEach(vm.items) { appt in
                                NavigationLink {
                                    AppointmentDetailPage(appointment: appt)
                                } label: {
                                    AppointmentCard(
                                        patientName: appt.patientName,
                                        analysisName: appt.analysisName,
                                        dateText: appt.date.formatted(date: .numeric, time: .omitted),
                                        status: appt.status
                                    )
                                }
                                .buttonStyle(.plain)
                                .padding(.horizontal, 8)
                            }
                        }
                        .padding(.bottom, 24)
                    }
                    .padding(.horizontal, 16)
                }

                if vm.loading { ProgressView() }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "person.crop.circle")
                }
                ToolbarItem(placement: .principal) {
                    Text("NefroVida").font(.headline)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "bell")
                }
            }
            .task { await vm.load() }
            .alert("Error", isPresented: .constant(vm.error != nil)) { } message: {
                Text(vm.error ?? "")
            }
        }
    }
}
