import Foundation
import Observation
import Combine

@MainActor
final class AnalysisViewModel: ObservableObject {

    @Published private(set) var analyses: [Analysis] = []
    @Published private(set) var consultation: [Consultation] = []
    @Published var selectedAnalysis: Bool = false
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let getAnalysisUseCase: GetAnalysisUseCaseProtocol
    private let getConsultationUseCase: GetConsultationUseCaseProtocol

    init(getAnalysisUseCase: GetAnalysisUseCaseProtocol,
        getConsultationUseCase: GetConsultationUseCaseProtocol) {
        self.getAnalysisUseCase = getAnalysisUseCase
        self.getConsultationUseCase = getConsultationUseCase
    }

    func onAppear() {
        if !selectedAnalysis{
            Task { await loadAnalysis() }
        }
        Task { await loadConsultation() }
    }

    private func loadAnalysis() async {
        isLoading = true
        errorMessage = nil

        do {
            analyses = try await getAnalysisUseCase.execute()
            print("se obtuvo los datos correctamente")
        } catch {
            errorMessage = "❌ No se pudieron cargar los análisis."
            print("ERROR:", error)
        }

        isLoading = false
    }
    
    private func loadConsultation() async {
        isLoading = true
        errorMessage = nil

        do {
            consultation = try await getConsultationUseCase.execute()
        } catch {
            errorMessage = "❌ No se pudieron cargar las consultas."
            print("ERROR:", error)
        }

        isLoading = false
    }
}
