import SwiftUI

struct PostCard: View {
    let post: Post

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 36, height: 36)
                    .overlay(Image(systemName: "person.fill").foregroundColor(.white))

                Text(post.authorName)
                    .font(.nvSemibold)
                    .foregroundColor(Color.nvBrand)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Spacer()
                if let date = post.createdAt {
                    Text(DateFormats.shortTime.string(from: date))
                        .font(.nvSmall)
                        .foregroundColor(.gray)
                }
            }

            Text(post.content)
                .font(.nvBody)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(nil)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
    }
}

#Preview {
    PostCard(post: Post(id: 1, content: "Hola pacientes de nefrovida", authorName: "Manuel Bajos", authorId: 101, createdAt: Date()))
}
