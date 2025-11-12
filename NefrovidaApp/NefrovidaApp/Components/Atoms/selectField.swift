import SwiftUI

struct SelectField: View {
    let label: String
    let options: [String]
    @Binding var selection: String?
    var placeholder: String = "Selecciona una opción"

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)

            Picker(selection: Binding(
                get: { selection ?? "" },
                set: { selection = $0 }
            ), label:
                HStack {
                    Text(selection?.isEmpty == false ? selection! : placeholder)
                        .foregroundColor(selection == nil ? .gray : .primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3))
                )
            ) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.menu)
        }
        .padding(.horizontal)
    }
}


    #Preview {
        SelectField(
            label: "Elige una opción",
            options: ["Prueba", "Matriz"],
            selection: .constant(nil) // o .constant("Prueba")
        )
    }
