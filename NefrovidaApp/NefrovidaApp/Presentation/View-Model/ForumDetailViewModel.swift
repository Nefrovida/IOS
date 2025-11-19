import Foundation
import Combine

@MainActor
final class ForumDetailViewModel: ObservableObject {
    @Published private(set) var forum: Forum?
    @Published private(set) var posts: [Post] = []
    @Published private(set) var isLoading = false
    @Published public var errorMessage: String?

    private let getForumDetailsUC: GetForumDetailsUseCase
    private let joinForumUC: JoinForumUseCase
    private let forumId: Int

    init(forumId: Int, getForumDetailsUC: GetForumDetailsUseCase, joinForumUC: JoinForumUseCase) {
        self.forumId = forumId
        self.getForumDetailsUC = getForumDetailsUC
        self.joinForumUC = joinForumUC
    }

    func onAppear() {
        Task { await loadDetails() }
    }

    func loadDetails() async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }
        do {
            let (f, posts) = try await getForumDetailsUC.execute(forumId: forumId)
            self.forum = f
            self.posts = posts
        } catch {
            // Determine the HTTP error type if needed
            self.errorMessage = "No se pudo cargar el foro." 
        }
    }

    func joinForum() async -> Bool {
        do {
            return try await joinForumUC.execute(forumId: forumId)
        } catch {
            return false
        }
    }
}
