import SwiftUI

struct ReportCard: View {

    let title: String
    let specialty: String
    let doctor: String
    let date: String

    let recommendations: String
    let treatment: String

    let onDownloadReport: () -> Void

    @State private var expanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            //──────── HEADER ──────────────────────────────
            HStack(alignment: .top) {

                VStack(alignment: .leading, spacing: 6) {

                    Title(text: title)

                    Text("Especialidad: \(specialty)")
                        .font(.nvBody)
                        .foregroundStyle(.secondary)

                    Text(doctor)
                        .font(.nvBody)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 8) {

                    Text(date)
                        .font(.nvBody)
                        .foregroundStyle(.secondary)

                    nefroButton(
                        text: "Descargar",
                        color: Color(red: 0.90, green: 0.98, blue: 1.0),
                        textColor: Color.nvBrand,
                        vertical: 6,
                        horizontal: 10,
                        hasStroke: false,
                        textSize: 13,
                        action: onDownloadReport
                    )
                }
            }

            //──────── EXPAND BUTTON ───────────────────────
            Button {
                withAnimation(.spring()) { expanded.toggle() }
            } label: {
                HStack {
                    Text(expanded ? "Ocultar detalles" : "Mostrar detalles")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.nvBrand)

                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.nvBrand)
                }
            }

            //──────── INFO BOX (READ ONLY) ────────────────
            if expanded {
                VStack(alignment: .leading, spacing: 12) {

                    Text("Recomendaciones")
                        .font(.system(size: 15, weight: .bold))

                    Text(recommendations)
                        .font(.nvBody)
                        .foregroundColor(.black.opacity(0.85))
                        .fixedSize(horizontal: false, vertical: true)

                    Text("Tratamiento")
                        .font(.system(size: 15, weight: .bold))

                    Text(treatment)
                        .font(.nvBody)
                        .foregroundColor(.black.opacity(0.85))
                        .fixedSize(horizontal: false, vertical: true)

                }
                .padding()
                .background(Color.nvLightBlue.opacity(0.35))
                .cornerRadius(16)
            }

        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 4)
        )
        .padding(.horizontal)
    }
}

#Preview {
    ReportCard(
        title: "Evaluación Riñón",
        specialty: "Nefrología",
        doctor: "Dr. Gilberto Mora",
        date: "12/10/2025",
        recommendations: "Tomar 2L de agua al día",
        treatment: "Control cada 3 meses",
        onDownloadReport: { print("Descargar PDF") },
    )
}
