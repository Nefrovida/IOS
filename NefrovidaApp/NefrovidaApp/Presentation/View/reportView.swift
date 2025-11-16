import SwiftUI

struct ReportsView: View {
    
    let idUser: String
    @StateObject private var vm: ReportsViewModel

    init(idUser: String) {
        _vm = StateObject(wrappedValue: ReportsViewModel(
            idUser: idUser,
            getReportsUseCase: GetReportsUseCase(repository: ReportsRemoteRepository())
        ))
        self.idUser = idUser
    }

    var body: some View {
        VStack(spacing: 0) {
            UpBar()
            ScrollView {
                Title(text: "Mis análisis").padding(.top, 10)
                Text("Consulta tus reportes médicos y recomendaciones.")
                    .font(.nvBody)
                    .foregroundColor(.secondary)
                FilterableReportList(viewModel: vm)
            }
            BottomBar(idUser: idUser)
        }
        .background(Color(.systemGroupedBackground))
        .onAppear { vm.onAppear() }
    }
}

#Preview {
    ReportsView(idUser: "1")
}
