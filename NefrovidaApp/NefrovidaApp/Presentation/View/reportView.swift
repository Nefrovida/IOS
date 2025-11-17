import SwiftUI

// Main view to display the report screen for a specific user
struct ReportsView: View {
    
    // Unique identifier of the logged-in user (passed from previous screen)
    let idUser: String
    
    // ViewModel that handles fetching and managing report data
    @StateObject private var vm: ReportsViewModel

    // Custom initializer to inject the idUser and initialize the ViewModel
    init(idUser: String) {
        // Initialize the ViewModel with dependency injection:
        // - userId to fetch their reports
        // - GetReportsUseCase that contains the business logic
        _vm = StateObject(wrappedValue: ReportsViewModel(
            idUser: idUser,
            getReportsUseCase: GetReportsUseCase(repository: ReportsRemoteRepository())
        ))
        self.idUser = idUser
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
            
            // Bottom bar with app navigation, passing userId for routing context
            BottomBar(idUser: idUser)
        }
        .background(Color(.systemGroupedBackground)) // Use grouped background style
        .onAppear { vm.onAppear() } // Trigger initial data loading on first display
    }
}

// Preview for SwiftUI canvas
#Preview {
    ReportsView(idUser: "1")
}
