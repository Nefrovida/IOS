import Foundation
import Combine

@MainActor
final class ReportsViewModel: ObservableObject {

    enum Filter: String, CaseIterable {
        case all         = "Todos"
        case consultation = "Consultas"
        case analysis     = "Análisis"
    }

    @Published private(set) var reports: [Report] = []
    @Published var selectedFilter: Filter = .all
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

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
            return reports.filter { $0.type == "consultation" }
        case .analysis:
            return reports.filter { $0.type == "analysis" }
        }
    }

    func onAppear() {
        Task { await loadReports() }
    }

    func loadReports() async {
        isLoading = true
        errorMessage = nil

        do {
            reports = try await getReportsUseCase.execute(userId: idUser)
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
