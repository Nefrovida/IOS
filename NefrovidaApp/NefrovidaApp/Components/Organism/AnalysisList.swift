import SwiftUI

struct AnalysisList: View {

    @ObservedObject var viewModel: AnalysisViewModel

    var body: some View {
        VStack(spacing: 18) {

            if viewModel.isLoading {
                ProgressView("Cargando estudios…")
                    .padding(.top, 50)

            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding(.top, 40)

            } else {
                ScrollView {
                    VStack(spacing: 18) {
                        ForEach(viewModel.analyses) { item in
                            AnalysisTypeCard(
                                title: item.name,
                                description: item.description,
                                costoComunidad: item.communityCost,
                                costoGeneral: item.generalCost,
                                onSettings: {
                                    print("➡️ Análisis seleccionado:", item.name)
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
            }
        }
    }
}
