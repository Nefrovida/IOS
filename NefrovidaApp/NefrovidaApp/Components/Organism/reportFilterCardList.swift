import SwiftUI
import Combine
import Observation

// View to show a list of the reports.
// Get the viewModel that contains the data and the states.
struct FilterableReportList: View {
    
    // Check the ViewModel to refresh the view.
    @ObservedObject var viewModel: ReportsViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            
            // Loading / Error / Content States
            
            if viewModel.isLoading {
                ProgressView("Cargando reportes…")
                    .padding(.top, 20)
                
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        if let error = viewModel.errorMessage {
                            ErrorMessage(
                                message: error,
                                onDismiss: {
                                    viewModel.errorMessage = nil
                                }
                            )
                        }
                        // With the for check the reports that the api sends.
                        ForEach(viewModel.reports) { report in
                            
                            ReportCard(
                                // Clean the name of the analysis to show without extra spaces.
                                title: report.patientAnalysis.analysis.name
                                    .trimmingCharacters(in: .whitespaces),
                                
                                specialty: "Laboratorio Clínico",
                                doctor: "Especialista Nefrólogo",
                                
                                // Change the format of the date
                                date: DateFormats.isoTo(report.date, format: "dd/MM/yyyy"),
                                
                                recommendations: report.patientAnalysis.analysis.previous_requirements ?? "Sin recomendaciones",
                                treatment: report.interpretation ?? "Sin tratamiento",
                                
                                // Actions when you press the button.
                                onDownloadReport: { 
                                    viewModel.downloadReport(report: report)
                                }
                            )
                        }
                        
                    }
                    .padding(.vertical)
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
    }
}

struct IdentifiableURL: Identifiable {
    let id = UUID()
    let url: URL
}
