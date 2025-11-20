import SwiftUI

// Main view to display the report screen for a specific user
struct ReportsView: View {
    
    // Unique identifier of the logged-in user (passed from previous screen)
    let patientId: String
    
    // ViewModel that handles fetching and managing report data
    @StateObject private var vm: ReportsViewModel

    // Custom initializer to inject the idUser and initialize the ViewModel
    init(patientId: String) {
        // Initialize the ViewModel with dependency injection:
        // - userId to fetch their reports
        // - GetReportsUseCase that contains the business logic
        _vm = StateObject(wrappedValue: ReportsViewModel(
            patientId: patientId,
            getReportsUseCase: GetReportsUseCase(repository: ReportsRemoteRepository())
        ))
        self.patientId = patientId
    }

    var body: some View {
        VStack(spacing: 0) {
            
            // Top navigation bar
            UpBar()
            
            // Scrollable body showing a filterable list of reports
            ScrollView {
                Spacer()
                
                // Custom organism that displays a list of reports
                FilterableReportList(viewModel: vm)
            }
            

        }
        .background(Color(.systemGroupedBackground)) // Use grouped background style
        .onAppear { vm.onAppear() } // Trigger initial data loading on first display
    }
}

// Preview for SwiftUI canvas
#Preview {
    ReportsView(patientId: "1")
}
