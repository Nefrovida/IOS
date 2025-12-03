import Foundation
import Combine

@MainActor
final class ReportsViewModel: ObservableObject {

    // UI state
    @Published var analysisResults: [AnalysisResult] = []
    @Published var appointmentNotes: [AppointmentNote] = []

    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // Download state
    @Published var isDownloading: Bool = false
    @Published var downloadedFileURL: URL? = nil

    private let userId: String
    private let getReportsUseCase: GetReportsUseCaseProtocol
    private let downloadReportUseCase: DownloadReportUseCaseProtocol

    init(userId: String, 
         getReportsUseCase: GetReportsUseCaseProtocol,
         downloadReportUseCase: DownloadReportUseCaseProtocol) {
        self.userId = userId
        self.getReportsUseCase = getReportsUseCase
        self.downloadReportUseCase = downloadReportUseCase
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
    
    // Download Report
    func downloadReport(id: Int) {
        Task {
            await downloadReportAsync(id: id)
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
