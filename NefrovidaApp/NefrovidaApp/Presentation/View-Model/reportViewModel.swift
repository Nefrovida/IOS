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
    // Published UI State
    @Published var reports: [Report] = []          // Array of fetched reports to be shown in the UI
    @Published var isLoading: Bool = false         // Indicates whether data is being loaded
    @Published var isDownloading: Bool = false     // Indicates whether a report is being downloaded
    @Published var errorMessage: String? = nil     // Stores an error message to display in the UI if needed
    @Published var downloadedFileURL: URL? = nil   // Stores the URL of the downloaded file to trigger the share sheet

    // Dependencies
    let userId: String                          // ID of the patient whose reports need to be loaded
    private let getReportsUseCase: GetReportsUseCaseProtocol // Use case responsible for fetching reports
    private let downloadReportUseCase: DownloadReportUseCaseProtocol // Use case responsible for downloading reports

    // Initialization
    init(userId: String, 
         getReportsUseCase: GetReportsUseCaseProtocol,
         downloadReportUseCase: DownloadReportUseCaseProtocol) {
        self.userId = userId                 // Assign the patient ID passed by the previous screen
        self.getReportsUseCase = getReportsUseCase // Inject the use case that fetches the data
        self.downloadReportUseCase = downloadReportUseCase // Inject the use case that downloads the report
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

        isLoading = true                           // Show loading indicator in UI
        errorMessage = nil                         // Reset previous error
        
        do {
            let result = try await getReportsUseCase.execute(userId: userId)
           
            if result.isEmpty{
                self.reports = []
                isLoading = false
                return
            }
            self.reports = result                  // Save the list of reports returned by the repository
            
        } catch {
            errorMessage = "No se pudieron cargar los reportes."
            print("Error loading reports:", error)
        }

        isLoading = false
    }
    
    // Download Report
    func downloadReport(report: Report) {
        Task {
            await downloadReportAsync(id: report.resultId)
        }
    }
    
    private func downloadReportAsync(id: Int) async {
        isDownloading = true
        errorMessage = nil
        downloadedFileURL = nil
        
        do {
            let url = try await downloadReportUseCase.execute(id: id)
            downloadedFileURL = url
        } catch {
            errorMessage = "Error al descargar el reporte."
            print("Error downloading report:", error)
        }
        
        isDownloading = false
    }
}
