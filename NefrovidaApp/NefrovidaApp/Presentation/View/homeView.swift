import SwiftUI

struct HomeAnalysisView: View {

    @StateObject private var vm = AnalysisViewModel(
        getAnalysisUseCase: GetAnalysisUseCase(
            repository: AnalysisRemoteRepository()
        )
    )

    var body: some View {
        ZStack(alignment: .bottom) {

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {

                    // 🔹 TOP BAR
                    UpBar()

                    // 🔹 TITLE + SUBTITLE
                    VStack(alignment: .leading, spacing: 6) {
                        Title(text: "Análisis disponibles")

                        Text("Selecciona el estudio que deseas consultar.")
                            .font(.nvBody)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)

                    // 🔹 LIST ORGANISM
                    AnalysisList(viewModel: vm)
                        .padding(.bottom, 90)   // ⬅️ Leaves space for BottomBar
                        .onAppear { vm.onAppear() }
                }
                .frame(maxWidth: .infinity, alignment: .top)
            }

            // 🔹 FIXED BOTTOM BAR
            BottomBar()
                .background(.white)
        }
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    HomeAnalysisView()
}
