import SwiftUI

struct PostContentView: View {
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let url = extractURL(from: text) {
                // Split the text to show pre-url portion
                let parts = text.components(separatedBy: url.absoluteString)
                if !parts[0].isEmpty { Text(parts[0]) }
                Link(url.absoluteString, destination: url)
                if parts.count > 1 && !parts[1].isEmpty { Text(parts[1]) }
            } else {
                Text(text)
            }
        }
        .font(.nvBody)
        .foregroundColor(.black)
    }

    private func extractURL(from text: String) -> URL? {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else { return nil }
        let range = NSRange(text.startIndex ..< text.endIndex, in: text)
        let matches = detector.matches(in: text, options: [], range: range)
        if let match = matches.first, let range = Range(match.range, in: text) {
            return URL(string: String(text[range]))
        }
        return nil
    }
}

#Preview {
    Group {
        PostContentView(text: "Hola pacientes de nefrovida")
        PostContentView(text: "Aqui les dejo el link: https://www.youtube.com/watch?v=dQw4w9WgXcQ")
    }
}
