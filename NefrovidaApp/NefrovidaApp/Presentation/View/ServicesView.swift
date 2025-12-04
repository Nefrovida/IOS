import SwiftUI

struct ServicesView: View {
    let userId: String
    
    enum ServiceFilter: Hashable {
        case analysis
        case consultations
    }
    
    @State private var selectedFilter: ServiceFilter = .analysis
    
    @StateObject private var vm = AnalysisViewModel(
        getAnalysisUseCase: GetAnalysisUseCase(repository: AnalysisRemoteRepository()),
        getConsultationUseCase: GetConsultationUseCases(repository: ConsultationRemoteRepository())
    )
    
    // POPUP
    @State private var showNefroPop = false
    @State private var selectedItem: Any?
    @State private var popupTitle = ""
    @State private var popupDescription = ""
    @State private var popupIndication = ""
    
    // NAVIGATION
    @State private var selectedAnalysis: Analysis?
    @State private var selectedConsultation: Consultation?
    
    // ==================================
    // ONLY ANALYSIS SHOW POPUP
    // ==================================
    private func showInfo(for item: Any) {
        
        // CONSULTATION → navega directo
        if let c = item as? Consultation {
            selectedConsultation = c
            return
        }
        
        // ANALYSIS → popup
        if let a = item as? Analysis {
            selectedItem = a
            popupTitle = "Sobre este análisis"
            popupDescription = a.description
            popupIndication = a.previousRequirements.isEmpty
                ? "No requiere preparación especial."
                : a.previousRequirements
            
            showNefroPop = true
        }
    }
    
    private func continueAction() {
        showNefroPop = false
        
        if let a = selectedItem as? Analysis {
            selectedAnalysis = a
        }
    }
    
    
    // =========================
    // LISTAS SEPARADAS
    // =========================
    private var analysisListView: some View {
        ForEach(vm.analyses) { item in
            AnalysisTypeCard(
                title: item.name,
                description: item.description,
                costoComunidad: item.communityCost,
                costoGeneral: item.generalCost,
                isAnalysis: true,
                onSettings: { showInfo(for: item) }
            )
        }
        .navigationDestination(item: $selectedAnalysis) { a in
            analysisView(
                analysisId: a.id,
                userId: userId
            )
            .navigationTitle(a.name)
        }
    }
    
    private var consultationListView: some View {
        ForEach(vm.consultation) { item in
            AnalysisTypeCard(
                title: item.nameConsultation,
                description: "Consulta con un especialista",
                costoComunidad: "\(item.communityCost)",
                costoGeneral: "\(item.generalCost)",
                isAnalysis: false,
                onSettings: { showInfo(for: item) }  // → Navega directo
            )
        }
        .navigationDestination(item: $selectedConsultation) { c in
            appointmentView(
                appointmentId: c.appointmentId,
                userId: userId
            )
            .navigationTitle(c.nameConsultation)
        }
    }
    
    // =========================
    // BODY
    // =========================
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    
                    UpBar()
                    
                    // Picker
                    Picker("Tipo", selection: $selectedFilter) {
                        Text("Análisis").tag(ServiceFilter.analysis)
                        Text("Consultas").tag(ServiceFilter.consultations)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    if vm.isLoading {
                        ProgressView("Cargando...")
                            .padding(.top, 30)
                        
                    } else if let err = vm.errorMessage {
                        Text(err)
                            .foregroundColor(.red)
                            .padding()
                        
                    } else {
                        VStack(spacing: 14) {
                            
                            if selectedFilter == .analysis {
                                analysisListView
                            } else {
                                consultationListView
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 90)
                    }
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .onAppear { vm.onAppear() }
        
        // POPUP SOLO ANALISIS
        .overlay(
            showNefroPop ?
            ZStack {
                Color.black.opacity(0.45)
                    .ignoresSafeArea()
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
            } : nil
        )
    }
}
