
    import SwiftUI

struct ServicesView: View {
    let userId: String
    // ViewModel for the view, initialized with use cases for both analysis and consultation
    @StateObject private var vm = AnalysisViewModel(
        getAnalysisUseCase: GetAnalysisUseCase(repository: AnalysisRemoteRepository()),
        getConsultationUseCase: GetConsultationUseCases(repository: ConsultationRemoteRepository())
    )
    
    // State variables for popup management
    @State private var showNefroPop = false
    @State private var selectedItem: Any?
    @State private var popupTitle = ""
    @State private var popupDescription = ""
    @State private var popupIndication = ""
    
    // Function to handle analysis selection
    private func selectAnalysis(_ analysis: Any) {
        selectedItem = analysis
        if let a = analysis as? Analysis {
            popupTitle = "¡Importante!"
            popupDescription = """
            ¿Para qué sirve este estudio?
            \(a.description)
            """
            popupIndication = a.previousRequirements.isEmpty ? "No se requieren preparaciones especiales." : a.previousRequirements
        } else if let c = analysis as? Consultation {
            popupTitle = "¡Confirmar Consulta!"
            popupDescription = """
            Tipo de consulta: \(c.nameConsultation)
            
            Esta consulta te permitirá recibir atención médica especializada para tu condición.
            """
            popupIndication = "Asegúrate de tener toda la documentación médica necesaria y llegar 15 minutos antes de tu cita."
        }
        showNefroPop = true
    }
    
    // Function to handle continue action from popup
    private func continueAction() {
        showNefroPop = false
        if let analysis = selectedItem as? Analysis {
             selectedAnalysis = analysis 
            print("Redirecting to analysis details:", analysis.name)
        } else if let consultation = selectedItem as? Consultation {
            print("Redirecting to consultation booking:", consultation.nameConsultation)

        }
    }

    // Status to control navigation
    @State private var selectedConsultation: Consultation?
    @State private var selectedAnalysis: Analysis?
    
    var body: some View {
        ZStack(alignment: .bottom) {  // Container that lets us overlay views

            // Main scrollable content
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
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

                                        onSettings: { selectAnalysis(a) }
                                    )
                                }
                                .navigationDestination(item: $selectedAnalysis) { analysis in
                                    analysisView( // Cambiar a la vista de analysis cuando ya este hecha
                                        analysisId: analysis.id,
                                        userId: userId
                                    )
                                    .navigationTitle(analysis.name)
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
                                        onSettings: { selectedConsultation = c }

                                    )
                                }
                                // Programmatic navigation: activated when selectedConsultation is not nil
                                .navigationDestination(item: $selectedConsultation) { consultation in
                                    appointmentView(
                                        appointmentId: consultation.appointmentId,
                                        userId: userId
                                    )
                                    .navigationTitle(consultation.nameConsultation)
                                }
                            }
                        }
                        .padding(.horizontal)     // Horizontal padding for layout
                        .padding(.bottom, 90)     // Leave space for the BottomBar
                    }
                }
            }

            // Fixed bottom navigation/action bar
        }
        .background(Color(.systemGroupedBackground)) // System-like grouped background
        .onAppear { vm.onAppear() } // Trigger ViewModel load when view appears
        .overlay(
            // NefroPop overlay
            showNefroPop ? 
            ZStack {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { showNefroPop = false }
                
                nefroPop(
                    title: popupTitle,
                    description: popupDescription,
                    subtitle: "Requisitos",
                    indication: popupIndication,
                    buttonText: "Continuar",
                    buttonAction: continueAction,
                    closeAction: { showNefroPop = false }
                )
            }
            : nil
        )
    }
}

