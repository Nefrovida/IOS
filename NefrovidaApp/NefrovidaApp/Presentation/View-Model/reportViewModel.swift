import Foundation
import Combine

@MainActor
final class ReportsViewModel: ObservableObject {

    // Published UI State
    @Published var reports: [Report] = []          // Array of fetched reports to be shown in the UI
    @Published var isLoading: Bool = false         // Indicates whether data is being loaded
    @Published var errorMessage: String? = nil     // Stores an error message to display in the UI if needed

    // Dependencies
    let patientId: String                          // ID of the patient whose reports need to be loaded
    private let getReportsUseCase: GetReportsUseCaseProtocol // Use case responsible for fetching reports

    // Initialization
    init(patientId: String, getReportsUseCase: GetReportsUseCaseProtocol) {
        self.patientId = patientId                 // Assign the patient ID passed by the previous screen
        self.getReportsUseCase = getReportsUseCase // Inject the use case that fetches the data
    }

    // Lifecycle
    func onAppear() {
        // Called when the view appears — starts the asynchronous loading
        Task { await loadReports() }
    }

    // Data Loading
    private func loadReports() async {
        isLoading = true                           // Show loading indicator in UI
        errorMessage = nil                         // Reset previous error

        do {
            let result = try await getReportsUseCase.execute(patientId: patientId)
            self.reports = result                  // Save the list of reports returned by the repository
            print("Reports loaded:", result)
        } catch {
            // If something goes wrong, save a generic error message for the UI
            errorMessage = "No se pudieron cargar los reportes."
            print("Error loading reports:", error)
        }

        isLoading = false                          // Hide loading indicator
    }
}
