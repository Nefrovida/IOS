import SwiftUI
import Combine
import Observation

// View to show a list of the reports.
// Get the viewModel that contains the data and the states.
struct FilterableReportList: View {
    
    // Check the ViewModel to refresh the view.
    @ObservedObject var viewModel: ReportsViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            
            //──────────────────────────────────────
            // 1) Result of analysis
            if !viewModel.analysisResults.isEmpty {
                Section("Resultados de análisis") {
                    ForEach(viewModel.analysisResults) { result in
                        ReportCard(
                            title: result.patientAnalysis.analysis.name.trimmingCharacters(in: .whitespaces),
                            date: DateFormats.isoTo(result.date, format: "dd/MM/yyyy"),
                            recommendations: result.patientAnalysis.analysis.description,
                            interpretation: result.interpretation ?? "Sin tratamiento",
                            onDownloadReport: { viewModel.downloadReport(id: result.id) }
                        )
                    }
                }
            }
            
            //──────────────────────────────────────
            // 2) Appointment Notes
            if !viewModel.appointmentNotes.isEmpty {
                Section("Notas de consulta") {
                    ForEach(viewModel.appointmentNotes) { note in
                        NoteCard(note: note)
                    }
                }
            }
        }
        .sheet(item: Binding(
            get: { viewModel.downloadedFileURL.map { IdentifiableURL(url: $0) } },
            set: { _ in viewModel.downloadedFileURL = nil }
        )) { identifiableURL in
            ShareSheet(activityItems: [identifiableURL.url])
        }
        .overlay {
            if viewModel.isDownloading {
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
    }
}

struct IdentifiableURL: Identifiable {
    let id = UUID()
    let url: URL
}
