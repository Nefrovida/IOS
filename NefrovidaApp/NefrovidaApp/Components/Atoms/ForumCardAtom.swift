import SwiftUI

struct ForumCard: View {
    let forum: Forum
    let isMember: Bool
    let onEnter: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 48, height: 48)
                .overlay(Image(systemName: "person.fill").foregroundColor(.white))

            VStack(alignment: .leading, spacing: 4) {
                Text(forum.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.nvBrand)
                Text(forum.description)
                    .font(.nvSmall)
                    .foregroundColor(.gray)
            }
            Spacer()
            VStack(alignment: .trailing) {
                if isMember {
                    Text("Miembro").font(.nvSmall).foregroundColor(.gray)
                }
                Button(action: onEnter) {
                    Text("Entrar")
                        .fontWeight(.semibold)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.nvLightBlue)
                        .foregroundColor(.black)
                        .cornerRadius(12)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    ForumCard(forum: Forum(id: 1, name: "Foro 1", description: "Foro para los pacientes de nefrovida", publicStatus: true, active: true, createdAt: Date()), isMember: true, onEnter: {})
}
