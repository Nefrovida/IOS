//
//  ReportsView.swift
//  NefrovidaApp
//
//  Created by Manuel Bajos
//

import SwiftUI

// Selector of the view
enum ReportSection: String, CaseIterable, Identifiable {
    case analysis = "Análisis"
    case notes = "Notas"

    var id: String { self.rawValue }
}

// Main view to display the report screen for a specific user
struct ReportsView: View {
    
    let userId: String
    
    // ViewModel that handles fetching and managing report data
    @StateObject private var vm: ReportsViewModel
    
    // State to control the section
    @State private var selectedTab: ReportSection = .analysis

    // Custom initializer to inject the idUser
    // and initialize the ViewModel
    init(userId: String) {
        _vm = StateObject(wrappedValue: ReportsViewModel(
            userId: userId,
            getReportsUseCase: GetReportsUseCase(repository: ReportsRemoteRepository())
        ))
        self.userId = userId
    }

    var body: some View {
        VStack(spacing: 0) {
            
            //─────────────────────────
            // Top navigation bar
            //─────────────────────────
            UpBar()
            
            //─────────────────────────
            // Selector
            //─────────────────────────
            Picker("Tipo", selection: $selectedTab) {
                Text("Resultados").tag(ReportSection.analysis)
                Text("Notas").tag(ReportSection.notes)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 8)

            //─────────────────────────
            // Content
            //─────────────────────────
            ScrollView {

                if vm.isLoading {
                    ProgressView("Cargando…")
                        .padding(.top, 40)

                } else if let err = vm.errorMessage {
                    VStack(spacing: 10) {
                        Text(err)
                            .foregroundStyle(.red)
                        Button("Reintentar") { vm.onAppear() }
                    }
                    .padding(.top, 40)

                } else {
                    // View depending of the selection
                    switch selectedTab {
                        
                    case .analysis:
                        if vm.analysisResults.isEmpty {
                            EmptyState(text: "No hay resultados de análisis.")
                        } else {
                            VStack(spacing: 14) {
                                ForEach(vm.analysisResults) { result in
                                    ReportCard(
                                        title: result.patientAnalysis.analysis.name
                                            .trimmingCharacters(in: .whitespaces),
                                        specialty: "Laboratorio Clínico",
                                        doctor: "Especialista Nefrólogo",
                                        date: DateFormats.isoTo(result.date, format: "dd/MM/yyyy"),
                                        recommendations: result.patientAnalysis.analysis.description,
                                        treatment: result.interpretation ?? "Sin tratamiento",
                                        onViewReport: { print("Ver:", result.path) },
                                        onDownloadReport: { print("Descargar:", result.path) }
                                    )
                                }
                            }
                            .padding(.top, 12)
                        }

                    case .notes:
                        if vm.appointmentNotes.isEmpty {
                            EmptyState(text: "No hay notas de consulta.")
                        } else {
                            VStack(spacing: 14) {
                                ForEach(vm.appointmentNotes) { note in
                                    NoteCard(note: note)
                                }
                            }
                            .padding(.top, 12)
                        }
                    }
                }
            }

        }
        .background(Color(.systemGroupedBackground))
        .onAppear { vm.onAppear() }
    }
}


//────────────────────────────
// Component to use when there
// is not reports notes.
//────────────────────────────
private struct EmptyState: View {
    let text: String
    
    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            Text(text)
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.top, 20)
        }
        .frame(maxWidth: .infinity, minHeight: 200)
    }
}

#Preview {
    ReportsView(userId:"474be354-8e34-4168-b9cf-3d6f0526ce53")
}
