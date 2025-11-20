import SwiftUI
import Combine
import Observation

struct FilterableReportList: View {
    
    @ObservedObject var viewModel: ReportsViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            
            // Segmented Filter
            HStack {
                ForEach(ReportsViewModel.Filter.allCases, id: \.self) { filter in
                    let isActive = viewModel.selectedFilter == filter
                    nefroButton(
                        text: filter.rawValue,
                        color: isActive ? .nvBrand : .white,
                        textColor: isActive ? .white : .nvBrand,
                        vertical: 6,
                        horizontal: 14,
                        hasStroke: !isActive,
                        textSize: 14
                    ) {
                        viewModel.selectFilter(filter)
                    }
                }
            }
            .padding(.horizontal)
            
            if viewModel.isLoading {
                ProgressView("Cargando reportes…")
                    .padding(.top, 20)
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(viewModel.filteredReports) { report in
                            ReportCard(
                                title: report.patientAnalysis.analysis.name.trimmingCharacters(in: .whitespaces),
                                specialty: "Laboratorio Clínico",
                                doctor: "Especialista Nefrólogo",
                                date: formatDate(report.date),
                                recommendations: report.patientAnalysis.analysis.previous_requirements ?? "Sin recomendaciones",
                                treatment: report.interpretation ?? "Sin tratamiento",
                                onViewReport: { print("🔍 Ver reporte:", report.path) },
                                onDownloadReport: { print("⬇️ Descargar:", report.path) }
                            )
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
    }
    
    private func formatDate(_ raw: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: raw) {
            let out = DateFormatter()
            out.dateFormat = "dd/MM/yyyy"
            return out.string(from: date)
        }
        return raw
    }
}
