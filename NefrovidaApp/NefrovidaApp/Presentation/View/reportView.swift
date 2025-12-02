import SwiftUI

// Main view to display the report screen for a specific user
struct ReportsView: View {
    
    // Unique identifier of the logged-in user (passed from previous screen)
    let userId: String
    
    // ViewModel that handles fetching and managing report data
    @StateObject private var vm: ReportsViewModel

    // Custom initializer to inject the idUser and initialize the ViewModel
    init(userId: String) {
        // Initialize the ViewModel with dependency injection:
        // - userId to fetch their reports
        // - GetReportsUseCase that contains the business logic
        // - DownloadReportUseCase to handle downloads
        let repository = ReportsRemoteRepository()
        _vm = StateObject(wrappedValue: ReportsViewModel(
            userId: userId,
            getReportsUseCase: GetReportsUseCase(repository: repository),
            downloadReportUseCase: DownloadReportUseCase(repository: repository)
        ))
        self.userId = userId
    }

    var body: some View {
        VStack(spacing: 0) {
            
            // Top navigation bar
            UpBar()
            
            // Scrollable body showing a filterable list of reports
            ScrollView {
                Spacer()
                
                // Custom organism that displays a list of reports
                if vm.reports.isEmpty{
                    Spacer()
                    Text("No tiene reportes para mostrar")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.top, 40)
                }else{
                    FilterableReportList(viewModel: vm)
                }
            }
            

        }
        .background(Color(.systemGroupedBackground)) // Use grouped background style
        .onAppear { vm.onAppear() } // Trigger initial data loading on first display
    }
}

// Preview for SwiftUI canvas
#Preview {
    ReportsView(userId:"474be354-8e34-4168-b9cf-3d6f0526ce53")
}
