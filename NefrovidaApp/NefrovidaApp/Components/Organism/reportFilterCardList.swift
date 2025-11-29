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
    }
}
