import SwiftUI

struct HomeView: View {
    let user: LoginEntity?
    // ViewModel for the view, initialized with use cases for both analysis and consultation
    @StateObject private var vm = AnalysisViewModel(
        getAnalysisUseCase: GetAnalysisUseCase(repository: AnalysisRemoteRepository()),
        getConsultationUseCase: GetConsultationUseCases(repository: ConsultationRemoteRepository())
    )

    var body: some View {
        ZStack(alignment: .bottom) {  // Container that lets us overlay views

            // Main scrollable content
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {

                    UpBar() // Top bar (e.g., logo or header)

                    // ---------- SELECTOR ----------
                    HStack(spacing: 12) {
                        // Button to toggle to "Analysis" view
                        nefroButton(
                            text: "Analysis",
                            color: vm.selectedAnalysis ? .nvBrand : .white,
                            textColor: vm.selectedAnalysis ? .white : .nvBrand,
                            vertical: 10,
                            horizontal: 22,
                            hasStroke: !vm.selectedAnalysis, // Unselected button shows border
                            textSize: 14
                        ) {
                            withAnimation { vm.selectedAnalysis = true } // Switch to analysis view
                        }

                        // Button to toggle to "Consultation" view
                        nefroButton(
                            text: "Consultations",
                            color: !vm.selectedAnalysis ? .nvBrand : .white,
                            textColor: !vm.selectedAnalysis ? .white : .nvBrand,
                            vertical: 10,
                            horizontal: 22,
                            hasStroke: vm.selectedAnalysis, // Unselected button shows border
                            textSize: 14
                        ) {
                            withAnimation { vm.selectedAnalysis = false } // Switch to consultation view
                        }
                    }
                    .padding(.horizontal)

                    // CONTENT
                    if vm.isLoading {
                        // Loading indicator while data is being fetched
                        ProgressView("Cargando...")

                    } else if let error = vm.errorMessage {
                        // Display any error that occurred during loading
                        Text(error).foregroundColor(.red)

                    } else {
                        VStack(spacing: 16) {
                            // Show list of analysis cards when in analysis mode
                            if vm.selectedAnalysis {
                                ForEach(vm.analyses) { a in
                                    AnalysisTypeCard(
                                        title: a.name,
                                        description: a.description,
                                        costoComunidad: a.communityCost,
                                        costoGeneral: a.generalCost,
                                        isAnalysis: true,
                                        onSettings: { print("Open details:", a.name) }
                                    )
                                }
                            } else {
                                // Show list of consultation cards when in consultation mode
                                ForEach(vm.consultation) { c in
                                    AnalysisTypeCard(
                                        title: c.nameConsultation,
                                        description: "Consult with a specialist",
                                        costoComunidad: "\(c.communityCost)",
                                        costoGeneral: "\(c.generalCost)",
                                        isAnalysis: false,
                                        onSettings: { print("Open details:", c.nameConsultation) }
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)     // Horizontal padding for layout
                        .padding(.bottom, 90)     // Leave space for the BottomBar
                    }
                }
            }

            // Fixed bottom navigation/action bar
            BottomBar().background(.white)
        }
        .background(Color(.systemGroupedBackground)) // System-like grouped background
        .onAppear { vm.onAppear() } // Trigger ViewModel load when view appears
    }
}

#Preview {
    HomeView(user: nil)
}
