import SwiftUI

struct ReportsView: View {

    let idUser: String
    @StateObject private var vm: ReportsViewModel

    init(idUser: String) {
        _vm = StateObject(
            wrappedValue: ReportsViewModel(
                idUser: idUser,
                getReportsUseCase: GetReportsUseCase(repository: ReportsRemoteRepository())
            )
        )
        self.idUser = idUser
    }

    var body: some View {
        VStack(spacing: 0) {

            // TOP BAR
            UpBar()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 12) {

                    //  TITLE
                    Title(text: "Mis análisis")
                        .padding(.top, 8)

                    //  SUBTITLE
                    Text("Consulta tus reportes y recomendaciones médicas.")
                        .font(.nvBody)
                        .foregroundStyle(.secondary)

                    //  FILTER + LIST
                    FilterableReportList(viewModel: vm)
                        .padding(.top, 4)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 80) // Leave space for bottom bar
            }
            .onAppear { vm.onAppear() }

            // FIXED BOTTOM BAR
            BottomBar(idUser: idUser)
        }
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    ReportsView(idUser: "1")
}
