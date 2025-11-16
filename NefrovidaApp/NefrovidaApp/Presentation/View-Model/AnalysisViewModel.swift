import Foundation
import Observation
import Combine

@MainActor
final class AnalysisViewModel: ObservableObject {

    @Published private(set) var analyses: [Analysis] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let getAnalysisUseCase: GetAnalysisUseCaseProtocol

    init(getAnalysisUseCase: GetAnalysisUseCaseProtocol) {
        self.getAnalysisUseCase = getAnalysisUseCase
    }

    func onAppear() {
        Task { await loadAnalysis() }
    }

    private func loadAnalysis() async {
        isLoading = true
        errorMessage = nil

        do {
            analyses = try await getAnalysisUseCase.execute()
        } catch {
            errorMessage = "❌ No se pudieron cargar los análisis."
            print("ERROR:", error)
        }

        isLoading = false
    }
}
