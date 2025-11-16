import Foundation
import Combine

@MainActor
final class ReportsViewModel: ObservableObject {   // <-- IMPORTANTE

    enum Filter: String, CaseIterable {
        case all = "Todos"
        case consultation = "Consulta"
        case analysis = "Análisis"
    }

    @Published var reports: [Report] = []
    @Published var selectedFilter: Filter = .all
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    let idUser: String
    private let getReportsUseCase: GetReportsUseCaseProtocol

    init(idUser: String, getReportsUseCase: GetReportsUseCaseProtocol) {
        self.idUser = idUser
        self.getReportsUseCase = getReportsUseCase
    }

    var filteredReports: [Report] {
        switch selectedFilter {
        case .all:
            return reports
        case .consultation:
            return reports.filter { $0.patient_analysis.analysis_status == "CONSULTATION" }
        case .analysis:
            return reports.filter { $0.patient_analysis.analysis_status == "LAB" }
        }
    }

    func onAppear() {
        Task { await loadReports() }
    }

    private func loadReports() async {
        isLoading = true
        errorMessage = nil

        do {
            let result = try await getReportsUseCase.execute(userId: idUser)
            self.reports = result
        } catch {
            errorMessage = "No se pudieron cargar los reportes."
            print("Error:", error)
        }
        
        isLoading = false
    }

    func selectFilter(_ filter: Filter) {
        selectedFilter = filter
    }
}
