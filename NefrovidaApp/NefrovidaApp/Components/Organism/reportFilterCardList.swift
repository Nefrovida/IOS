import SwiftUI

struct FilterableReportList: View {
    
    @ObservedObject var viewModel: ReportsViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            
            // ───── Segmented Filter (Consultas / Análisis / Todos)
            HStack(spacing: 10) {
                ForEach(ReportsViewModel.Filter.allCases, id: \.self) { filter in
                    let isSelected = viewModel.selectedFilter == filter
                    
                    nefroButton(
                        text: filter.rawValue,
                        color: isSelected ? Color.nvBrand : .white,
                        textColor: isSelected ? .white : Color.nvBrand,
                        vertical: 6,
                        horizontal: 14,
                        hasStroke: !isSelected,
                        textSize: 14
                    ) {
                        viewModel.selectFilter(filter)
                    }
                }
            }
            .padding(.horizontal)
            
            // ───── Loader, error message, or report list
            if viewModel.isLoading {
                ProgressView("Cargando reportes...")
                    .padding(.top, 40)
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else if viewModel.filteredReports.isEmpty {
                Text("Aún no tienes reportes registrados.")
                    .font(.nvBody)
                    .foregroundStyle(.secondary)
                    .padding(.top, 40)
            } else {
                ScrollView {
                    VStack(spacing: 18) {
                        ForEach(viewModel.filteredReports) { report in
                            ReportCard(
                                title: report.title ?? "Sin título",
                                specialty: report.specialty ?? "Sin especialidad",
                                doctor: report.doctor ?? "Médico desconocido",
                                date: format(dateString: report.date),
                                recommendations: report.recommendations ?? "Sin recomendaciones",
                                treatment: report.treatment ?? "Sin tratamiento",
                                onViewReport: {
                                    print("👀 Ver: \(report.path)")
                                },
                                onDownloadReport: {
                                    print("⬇️ Descargar: \(report.path)")
                                }
                            )
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
    }
    
    private func format(dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"     // input desde backend
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter.string(from: date)
        }
        return dateString
    }
}

#Preview {
    let vm = ReportsViewModel(
        idUser: "demo",
        getReportsUseCase: GetReportsUseCase(
            repository: ReportsRemoteRepository()
        )
    )

    return FilterableReportList(viewModel: vm)
}
