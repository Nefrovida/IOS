import Foundation
import Alamofire

private struct ForumDTO: Codable {
    let forum_id: Int
    let name: String
    let description: String
    let public_status: Bool
    let active: Bool
    let creation_date: String?
    let posts: [PostDTO]?

    func toDomain() -> Forum {
        let date = ISO8601DateFormatter().date(from: creation_date ?? "")
        return Forum(id: forum_id, name: name, description: description, publicStatus: public_status, active: active, createdAt: date)
    }
}

private struct PostDTO: Codable {
    let id: Int
    let content: String
    let author: AuthorDTO
    let created_at: String?

    func toDomain() -> Post {
        let date = ISO8601DateFormatter().date(from: created_at ?? "")
        return Post(id: id, content: content, authorName: author.name, authorId: author.id, createdAt: date)
    }
}

private struct AuthorDTO: Codable {
    let name: String
    let id: Int
}

public final class ForumRemoteRepository: ForumRepository {

    private let baseURL: String
    private let tokenProvider: () -> String?

    public init(baseURL: String, tokenProvider: @escaping () -> String? = { nil }) {
        self.baseURL = baseURL
        self.tokenProvider = tokenProvider
    }

    public func fetchForums(page: Int? = nil, limit: Int? = nil, search: String? = nil, isPublic: Bool? = nil) async throws -> [Forum] {
        let endpoint = "\(baseURL)/forums"
        var params: Parameters = [:]
        if let page = page { params["page"] = page }
        if let limit = limit { params["limit"] = limit }
        if let search = search { params["search"] = search }
        if let isPublic = isPublic { params["isPublic"] = isPublic }

        let headers = makeHeaders()

        let request = AF.request(endpoint, method: .get, parameters: params, headers: HTTPHeaders(headers)).validate()
        let result = await request.serializingData().response
        switch result.result {
        case .success(let data):
            if let jsonString = String(data: data, encoding: .utf8) {
                print("DEBUG: fetchForums raw response: \(jsonString)")
            }
            do {
                let decoder = JSONDecoder()
                // Try to decode a plain array first: [ForumDTO]
                if let dtoList = try? decoder.decode([ForumDTO].self, from: data) {
                    return dtoList.map { $0.toDomain() }
                }
                // Try container { "forums": [...] }
                if let container = try? decoder.decode([String: [ForumDTO]].self, from: data), let list = container["forums"] {
                    return list.map { $0.toDomain() }
                }
                // Otherwise, attempt to decode a wrapper with key "data" or throw
                if let wrapper = try? decoder.decode([String: [String: [ForumDTO]]].self, from: data) {
                    // Attempt to find the first array of forums in nested wrapper
                    for (_, value) in wrapper {
                        if let list = value["forums"] ?? value["data"] {
                            return list.map { $0.toDomain() }
                        }
                    }
                }
                
                // Try one more attempt to catch the specific decoding error for [ForumDTO] to print it
                _ = try decoder.decode([ForumDTO].self, from: data)
                
                // No recognized format found
                throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Unexpected forums response shape"))
            } catch {
                print("DEBUG: fetchForums decoding error: \(error)")
                throw error
            }
        case .failure(let error):
            print("DEBUG: fetchForums network error: \(error)")
            throw error
        }
    }

    public func fetchMyForums() async throws -> [Forum] {
        let endpoint = "\(baseURL)/forums/me"
        let headers = makeHeaders()
        let request = AF.request(endpoint, method: .get, headers: HTTPHeaders(headers)).validate()
        let result = await request.serializingData().response
        switch result.result {
        case .success(let data):
            if let jsonString = String(data: data, encoding: .utf8) {
                print("DEBUG: fetchMyForums raw response: \(jsonString)")
            }
            do {
                let decoder = JSONDecoder()
                // Same flexible decoding as fetchForums
                if let dtoList = try? decoder.decode([ForumDTO].self, from: data) {
                    return dtoList.map { $0.toDomain() }
                }
                if let container = try? decoder.decode([String: [ForumDTO]].self, from: data), let list = container["forums"] {
                    return list.map { $0.toDomain() }
                }
                
                // Try to decode [ForumDTO] again to get the specific error
                 _ = try decoder.decode([ForumDTO].self, from: data)

                throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Unexpected my forums response shape"))
            } catch {
                print("DEBUG: fetchMyForums decoding error: \(error)")
                throw error
            }
        case .failure(let error):
            if let data = result.data, let errorString = String(data: data, encoding: .utf8) {
                print("DEBUG: fetchMyForums error response body: \(errorString)")
            }
            print("DEBUG: fetchMyForums network error: \(error)")
            throw error
        }
    }

    public func fetchForum(by id: Int) async throws -> (Forum, [Post]) {
        let endpoint = "\(baseURL)/forums/\(id)"
        let headers = makeHeaders()
        let request = AF.request(endpoint, method: .get, headers: HTTPHeaders(headers)).validate()
        let result = await request.serializingData().response
        switch result.result {
        case .success(let data):
            do {
                let decoder = JSONDecoder()
                // Try to decode a response shaped as { "forum": { ... }, "posts": [...] }

                // Try typed container: {"forum": ForumDTO, "posts": [PostDTO]}
                if let resp = try? decoder.decode(ForumWithPostsDTO.self, from: data), let forumDTO = resp.forum {
                    let posts = resp.posts?.map { $0.toDomain() } ?? []
                    return (forumDTO.toDomain(), posts)
                }

                // Try to decode ForumDTO that includes posts property
                if let forumDTO = try? decoder.decode(ForumDTO.self, from: data) {
                    let posts = forumDTO.posts?.map { $0.toDomain() } ?? []
                    return (forumDTO.toDomain(), posts)
                }

                // Try to decode container {"posts": [...]}
                if let postsContainer = try? decoder.decode([String: [PostDTO]].self, from: data), let posts = postsContainer["posts"] {
                    // no forum returned; we can't proceed so throw
                    throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "No forum object found"))
                }

                throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Unexpected forum detail response shape"))
            } catch {
                throw error
            }
        case .failure(let error):
            throw error
        }
    }

    public func joinForum(id: Int) async throws -> Bool {
        let endpoint = "\(baseURL)/forums/\(id)/join"
        let headers = makeHeaders()
        let request = AF.request(endpoint, method: .post, headers: HTTPHeaders(headers)).validate()
        let result = await request.serializingData().response
        switch result.result {
        case .success:
            return true
        case .failure(let error):
            throw error
        }
    }

    // MARK: - Messages (Merged from develop)

    public func getMessages(forumId: Int) async throws -> [ForumMessageEntity] {
        let endpoint = "\(baseURL)/forums/\(forumId)/messages"
        let headers = makeHeaders()
        let request = AF.request(endpoint, method: .get, headers: HTTPHeaders(headers)).validate()
        let result = await request.serializingData().response
        switch result.result {
        case .success(let data):
            return try JSONDecoder().decode([ForumMessageEntity].self, from: data)
        case .failure(let error):
            throw error
        }
    }

    public func postMessage(forumId: Int, content: String) async throws -> ForumMessageEntity {
        let endpoint = "\(baseURL)/forums/\(forumId)/messages"
        let headers = makeHeaders()
        let params: [String: Any] = ["content": content]
        let request = AF.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers)).validate()
        let result = await request.serializingData().response
        switch result.result {
        case .success(let data):
            return try JSONDecoder().decode(ForumMessageEntity.self, from: data)
        case .failure(let error):
            throw error
        }
    }

    public func replyToMessage(forumId: Int, parentMessageId: Int, content: String) async throws -> ForumMessageEntity {
        let endpoint = "\(baseURL)/forums/\(forumId)/replies"
        let headers = makeHeaders()
        let params: [String: Any] = [
            "parentMessageId": parentMessageId,
            "content": content
        ]
        let request = AF.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers)).validate()
        let result = await request.serializingData().response
        switch result.result {
        case .success(let data):
            return try JSONDecoder().decode(ForumMessageEntity.self, from: data)
        case .failure(let error):
            throw error
        }
    }

    private func makeHeaders() -> [String: String] {
        var headers: [String: String] = ["Content-Type": "application/json"]
        if let token = tokenProvider() {
            print("DEBUG: Token found in makeHeaders: \(token.prefix(10))...")
            headers["Authorization"] = "Bearer \(token)"
        } else {
            print("DEBUG: No token found in makeHeaders")
        }
        return headers
    }

    // Helper DTO for responses shaped as { "forum": {...}, "posts": [...] }
    private struct ForumWithPostsDTO: Codable {
        let forum: ForumDTO?
        let posts: [PostDTO]?
    }
}
