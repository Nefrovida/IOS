import SwiftUI

struct HomeView: View {
    let user: LoginEntity?

    @StateObject private var vm = AnalysisViewModel(
        getAnalysisUseCase: GetAnalysisUseCase(repository: AnalysisRemoteRepository()),
        getConsultationUseCase: GetConsultationUseCases(repository: ConsultationRemoteRepository())
    )

    @State private var selectedConsultation: Consultation?
    @State private var selectedAnalysis: Analysis?

    var body: some View {
        ZStack(alignment: .bottom) {

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {

                    UpBar()

                    // --------- SEGMENTED CONTROL ----------
                    Picker("Selector", selection: $vm.selectedAnalysis) {
                        Text("Analysis")
                            .tag(true)

                        Text("Consultations")
                            .tag(false)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    // ------------- CONTENT --------------
                    if vm.isLoading {
                        ProgressView("Cargando...")

                    } else if let error = vm.errorMessage {
                        Text(error).foregroundColor(.red)

                    } else {
                        VStack(spacing: 16) {

                            // ------- MODE: ANALYSIS -------
                            if vm.selectedAnalysis {
                                ForEach(vm.analyses) { a in
                                    AnalysisTypeCard(
                                        title: a.name,
                                        description: a.description,
                                        costoComunidad: a.communityCost,
                                        costoGeneral: a.generalCost,
                                        isAnalysis: true,
                                        onSettings: { selectedAnalysis = a }
                                    )
                                }
                                .navigationDestination(item: $selectedAnalysis) { analysis in
                                    appointmentView(
                                        appointmentId: analysis.id,
                                        userId: user?.user_id ?? ""
                                    )
                                    .navigationTitle(analysis.name)
                                }
                            }

                            // ------- MODE: CONSULTATION -------
                            else {
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
                                .navigationDestination(item: $selectedConsultation) { consultation in
                                    appointmentView(
                                        appointmentId: consultation.appointmentId,
                                        userId: user?.user_id ?? ""
                                    )
                                    .navigationTitle(consultation.nameConsultation)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 90) // Bottom bar space
                    }
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .onAppear { vm.onAppear() }
    }
}

#Preview {
    NavigationStack {
        HomeView(user: nil)
    }
}
