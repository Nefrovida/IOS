import Foundation
import Combine

@MainActor
final class ReportsViewModel: ObservableObject {
    // The @MainActor ensures all UI-related updates happen on the main thread.
    // `ObservableObject` allows this ViewModel to notify SwiftUI views when data changes.

    // Enum used to filter reports by type
    enum Filter: String, CaseIterable {
        case all = "Todos"         // Show all reports
        case consultation = "Consulta" // Only consultation reports
        case analysis = "Análisis"     // Only laboratory analysis reports
    }

    // Published properties trigger UI updates when modified
    @Published var reports: [Report] = []              // Stores fetched reports
    @Published var selectedFilter: Filter = .all       // Current selected filter
    @Published var isLoading: Bool = false             // Tracks loading state
    @Published var errorMessage: String? = nil         // Stores error message if something fails

    // Dependencies
    let idUser: String                                // ID of the user to fetch reports for
    private let getReportsUseCase: GetReportsUseCaseProtocol // Business logic for fetching reports

    // Dependency initialization
    init(idUser: String, getReportsUseCase: GetReportsUseCaseProtocol) {
        self.idUser = idUser
        self.getReportsUseCase = getReportsUseCase
    }

    // Computed property to return filtered reports based on the selected filter
    var filteredReports: [Report] {
        switch selectedFilter {
        case .all:
            return reports
        case .consultation:
            // Filter where status indicates this was a medical consultation
            return reports.filter { $0.patient_analysis.analysis_status == "CONSULTATION" }
        case .analysis:
            // Filter where status indicates this was a lab analysis
            return reports.filter { $0.patient_analysis.analysis_status == "LAB" }
        }
    }

    // Called when the view appears to load reports
    func onAppear() {
        Task { await loadReports() }
    }

    // Fetches report data asynchronously
    private func loadReports() async {
        isLoading = true                    // Enable loading indicator
        errorMessage = nil                  // Reset previous errors

        do {
            // Execute the use case to fetch data
            let result = try await getReportsUseCase.execute(userId: idUser)
            self.reports = result           // Save result for the UI
        } catch {
            // Handle and store error for display
            errorMessage = "No se pudieron cargar los reportes."
            print("Error:", error)
        }
        
        isLoading = false                   // Disable loading indicator
    }

    // Allows UI components to change the selected filter
    func selectFilter(_ filter: Filter) {
        selectedFilter = filter
    }
}
