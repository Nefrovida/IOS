import Foundation

struct ForumRemoteRepository {
    private let baseURL = "http://localhost:3000/api/forums"

    func getMessages(forumId: Int) async throws -> [ForumMessageEntity] {
        guard let url = URL(string: "\(baseURL)/\(forumId)/messages") else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode([ForumMessageEntity].self, from: data)
    }

    func postMessage(forumId: Int, content: String) async throws -> ForumMessageEntity {
        guard let url = URL(string: "\(baseURL)/\(forumId)/messages") else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: ["content": content])
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(ForumMessageEntity.self, from: data)
    }

    func replyToMessage(forumId: Int, parentMessageId: Int, content: String) async throws -> ForumMessageEntity {
        guard let url = URL(string: "\(baseURL)/\(forumId)/replies") else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: [
            "parentMessageId": parentMessageId,
            "content": content
        ])
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(ForumMessageEntity.self, from: data)
    }
}
