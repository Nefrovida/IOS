import SwiftUI

struct HomeAnalysisView: View {

    @StateObject private var vm = AnalysisViewModel(
        getAnalysisUseCase: GetAnalysisUseCase(repository: AnalysisRemoteRepository()),
        getConsultationUseCase: GetConsultationUseCases(repository: ConsultationRemoteRepository())
    )

    var body: some View {
        ZStack(alignment: .bottom) {

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {

                    UpBar()


                    // SELECTOR
                    HStack(spacing: 12) {
                        nefroButton(
                            text: "Análisis",
                            color: vm.selectedAnalysis ? .nvBrand : .white,
                            textColor: vm.selectedAnalysis ? .white : .nvBrand,
                            vertical: 10,
                            horizontal: 22,
                            hasStroke: !vm.selectedAnalysis,
                            textSize: 14
                        ) {
                            withAnimation { vm.selectedAnalysis = true }
                        }

                        nefroButton(
                            text: "Consultas",
                            color: !vm.selectedAnalysis ? .nvBrand : .white,
                            textColor: !vm.selectedAnalysis ? .white : .nvBrand,
                            vertical: 10,
                            horizontal: 22,
                            hasStroke: vm.selectedAnalysis,
                            textSize: 14
                        ) {
                            withAnimation { vm.selectedAnalysis = false }
                        }
                    }
                    .padding(.horizontal)

                    // CONTENT
                    if vm.isLoading {
                        ProgressView("Cargando...")
                    } else if let error = vm.errorMessage {
                        Text(error).foregroundColor(.red)
                    } else {
                        VStack(spacing: 16) {

                            if vm.selectedAnalysis {
                                ForEach(vm.analyses) { a in
                                    AnalysisTypeCard(
                                        title: a.name,
                                        description: a.description,
                                        costoComunidad: a.communityCost,
                                        costoGeneral: a.generalCost,
                                        isAnalysis:true,
                                        onSettings: { print("🧪 Abrir detalles:", a.name) }
                                    )
                                }
                            } else {
                                ForEach(vm.consultation) { c in
                                    AnalysisTypeCard(
                                        title: c.nameConsultation,
                                        description: "Consulta con especialista",
                                        costoComunidad: "\(c.communityCost)",
                                        costoGeneral: "\(c.generalCost)",
                                        onSettings: { print("🩺 Abrir detalles:", c.nameConsultation) }
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 90)
                    }
                }
            }

            BottomBar().background(.white)
        }
        .background(Color(.systemGroupedBackground))
        .onAppear { vm.onAppear() }
    }
}

#Preview {
    HomeAnalysisView()
}
