import Foundation
import Combine

@MainActor
final class ReportsViewModel: ObservableObject {

    // UI state
    @Published var analysisResults: [AnalysisResult] = []
    @Published var appointmentNotes: [AppointmentNote] = []

    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let userId: String
    private let getReportsUseCase: GetReportsUseCaseProtocol

    init(userId: String, getReportsUseCase: GetReportsUseCaseProtocol) {
        self.userId = userId
        self.getReportsUseCase = getReportsUseCase
    }

    func onAppear() {
        Task { await loadReports() }
    }

    private func loadReports() async {
        isLoading = true
        errorMessage = nil

        do {
            let data = try await getReportsUseCase.execute(userId: userId)

            self.analysisResults = data.analysisResults
            self.appointmentNotes = data.appointmentNotes

        } catch {
            errorMessage = "No se pudieron cargar los reportes."
            print("Error loading reports:", error)
        }

        isLoading = false
    }
}
