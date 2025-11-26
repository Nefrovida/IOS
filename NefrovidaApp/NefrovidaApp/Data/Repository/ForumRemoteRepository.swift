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

// DTO for /forums/myForums endpoint which returns { forumId, name }
private struct MyForumDTO: Codable {
    let forumId: Int
    let name: String
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
                throw error
            }
        case .failure(let error):
            throw error
        }
    }
    
    public func fetchMyForums() async throws -> [Forum] {
        let endpoint = "\(baseURL)/forums/myForums"
        let headers = makeHeaders()
        let request = AF.request(endpoint, method: .get, headers: HTTPHeaders(headers)).validate()
        let result = await request.serializingData().response
        switch result.result {
        case .success(let data):
            do {
                let decoder = JSONDecoder()
                // The API returns [{ forumId, name }] not full forum objects
                let myForumsList = try decoder.decode([MyForumDTO].self, from: data)
                // Convert to Forum objects (with minimal data)
                return myForumsList.map { dto in
                    Forum(id: dto.forumId, name: dto.name, description: "", publicStatus: true, active: true, createdAt: nil)
                }
            } catch {
                throw error
            }
        case .failure(let error):
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
    
    // Posts a new message to the forum
    // Parameters:
    // forumId: The ID of the forum to post to
    // content: The message content
    // Returns: True if the message was posted successfully
    public func postMessage(forumId: Int, content: String) async throws -> Bool {
        let endpoint = "\(baseURL)/forums/\(forumId)"
        let headers = makeHeaders()
        // Backend expects "message" field, not "content"
        let params: [String: Any] = ["message": content]
        let request = AF.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers)).validate()
        let result = await request.serializingData().response
        switch result.result {
        case .success:
            return true
        case .failure(let error):
            throw error
        }
    }
    
    
    public func replyToMessage(forumId: Int, parentMessageId: Int, content: String) async throws -> ForumMessageEntity {
        let endpoint = "\(AppConfig.apiBaseURL)/forums/\(forumId)/replies"
        let headers = makeHeaders()
        let params: [String: Any] = [
            "parent_message_id": parentMessageId,
            "content": content
        ]
        let request = AF.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders(headers)).validate()
        let result = await request.serializingData().response
        switch result.result {
        case .success(let data):
            let decoder = JSONDecoder()
            if let entity = try? decoder.decode(ForumMessageEntity.self, from: data) {
                return entity
            }
            if let wrapper = try? decoder.decode(ForumMessageWrapperDTO.self, from: data) {
                return wrapper.data
            }
            return try decoder.decode(ForumMessageEntity.self, from: data)
        case .failure(let error):
            throw error
        }
    }
    
    public func fetchReplies(forumId: Int, messageId: Int, page: Int?, limit: Int?) async throws -> [ForumMessageEntity] {
        let endpoint = "\(AppConfig.apiBaseURL)/forums/\(forumId)/messages/\(messageId)/replies"
        var params: Parameters = [:]
        if let page = page { params["page"] = page }
        if let limit = limit { params["limit"] = limit }
        
        let headers = makeHeaders()
        let request = AF.request(endpoint, method: .get, parameters: params, headers: HTTPHeaders(headers)).validate()
        let result = await request.serializingData().response
        
        switch result.result {
        case .success(let data):
            let decoder = JSONDecoder()
            // Try to decode the wrapper { data: [...], pagination: {...} }
            if let wrapper = try? decoder.decode(RepliesResponseDTO.self, from: data) {
                return wrapper.data
            }
            // Fallback: try decoding array directly just in case
            if let list = try? decoder.decode([ForumMessageEntity].self, from: data) {
                return list
            }
            // If both fail, try one more time to let it throw and print error
            return try decoder.decode([ForumMessageEntity].self, from: data)
            
        case .failure(let error):
            throw error
        }
    }
    
    private func makeHeaders() -> [String: String] {
        var headers: [String: String] = ["Content-Type": "application/json"]
        if let token = tokenProvider() {
            headers["Authorization"] = "Bearer \(token)"
        }
        return headers
    }
    
    // Helper DTO for responses shaped as { "forum": {...}, "posts": [...] }
    private struct ForumWithPostsDTO: Codable {
        let forum: ForumDTO?
        let posts: [PostDTO]?
    }
    
    
    // MARK: - get the message from the forum
    public func getFeed(forumId: Int?, page: Int) async throws -> [ForumFeedItem] {
        var params: [String: Any] = ["page": page]
        
        if let forumId = forumId {
            params["forumId"] = forumId
        }
        
        let endpoint = "\(AppConfig.apiBaseURL)/forums/feed"
        
        let response = await AF.request(
            endpoint,
            method: .get,
            parameters: params,
            encoding: URLEncoding.default,
            headers: HTTPHeaders(makeHeaders())
        ).serializingData().response
        
        print(response.result)
        switch response.result {
        case .success(let data):
            let decoder = JSONDecoder()
            let dtoList = try decoder.decode([FeedDTO].self, from: data)
            return dtoList.map {$0.toDomain()}
            
        case .failure(let error):
            throw error
        }
    }
}
    // Helper DTO for wrapped message responses
    private struct ForumMessageWrapperDTO: Codable {
        let data: ForumMessageEntity
    }
    
    // Helper DTO for replies response
    private struct RepliesResponseDTO: Codable {
        let data: [ForumMessageEntity]
    }
    
