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
        // Initialize the ViewModel with dependency injection:
        // - userId to fetch their reports
        // - GetReportsUseCase that contains the business logic
        // - DownloadReportUseCase to handle downloads
        let repository = ReportsRemoteRepository()
        _vm = StateObject(wrappedValue: ReportsViewModel(
            userId: userId,
            getReportsUseCase: GetReportsUseCase(repository: repository),
            downloadReportUseCase: DownloadReportUseCase(repository: repository)
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
                                        date: DateFormats.isoTo(result.date, format: "dd/MM/yyyy"),
                                        recommendations: result.patientAnalysis.analysis.description,
                                        interpretation: result.interpretation ?? "Sin tratamiento",
                                        onDownloadReport: { vm.downloadReport(id: result.id) }
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
        .sheet(item: Binding(
            get: { vm.downloadedFileURL.map { IdentifiableURL(url: $0) } },
            set: { _ in vm.downloadedFileURL = nil }
        )) { identifiableURL in
            ShareSheet(activityItems: [identifiableURL.url])
        }
        .overlay {
            if vm.isDownloading {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    ProgressView("Descargando...")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
            }
        }
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
