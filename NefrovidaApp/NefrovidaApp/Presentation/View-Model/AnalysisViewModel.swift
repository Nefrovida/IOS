import Foundation
import Observation
import Combine

@MainActor
final class AnalysisViewModel: ObservableObject {

    // Published list of analysis services retrieved from the API
    @Published private(set) var analyses: [Analysis] = []
    
    // Published list of consultation services retrieved from the API
    @Published private(set) var consultation: [Consultation] = []
    
    // Tracks whether the selected view is for analysis (true) or consultation (false)
    @Published var selectedAnalysis: Bool = false

    // Indicates whether the ViewModel is currently loading data
    @Published private(set) var isLoading = false
    
    // Stores any error message that may be displayed to the user
    @Published var errorMessage: String?

    // Use case to fetch the list of analysis services
    private let getAnalysisUseCase: GetAnalysisUseCaseProtocol
    
    // Use case to fetch the list of consultation services
    private let getConsultationUseCase: GetConsultationUseCaseProtocol

    // Initialization with dependency injection for both use cases
    init(getAnalysisUseCase: GetAnalysisUseCaseProtocol,
         getConsultationUseCase: GetConsultationUseCaseProtocol) {
        self.getAnalysisUseCase = getAnalysisUseCase
        self.getConsultationUseCase = getConsultationUseCase
    }

    // Called when the view appears
    func onAppear() {
        if !selectedAnalysis {
            Task { await loadAnalysis() }      // Load analysis data only if the default is analysis
        }else{
            Task { await loadConsultation() }      // Always load consultations (could also be conditional)
        }
    }

    // Loads analysis data asynchronously
    private func loadAnalysis() async {
        isLoading = true              // Show loading indicator
        errorMessage = nil            // Reset previous errors

        do {
            analyses = try await getAnalysisUseCase.execute()  // Fetch data using use case
            print("Analysis data fetched successfully")        // Debug log
        } catch {
            errorMessage = "Error al cargar los análisis."         // Set user-friendly error message
            print("ERROR loading analyses:", error)             // Log underlying error
        }

        isLoading = false             // Hide loading indicator
    }

    // Loads consultation data asynchronously
    private func loadConsultation() async {
        isLoading = true
        errorMessage = nil

        do {
            consultation = try await getConsultationUseCase.execute()  // Fetch data using use case
            print("Consultation data fetched successfully")
        } catch {
            errorMessage = "Error al cargar las consultas."
            print("ERROR loading consultations:", error)
        }

        isLoading = false
    }
}
