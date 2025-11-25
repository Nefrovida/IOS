import Foundation
import Combine

@MainActor
final class ForumsViewModel: ObservableObject {
    @Published private(set) var forums: [Forum] = []
    @Published private(set) var myForums: [Forum] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let getForumsUC: GetForumsUseCase
    private let getMyForumsUC: GetMyForumsUseCase
    private let joinForumUC: JoinForumUseCase

    init(getForumsUC: GetForumsUseCase, getMyForumsUC: GetMyForumsUseCase, joinForumUC: JoinForumUseCase) {
        self.getForumsUC = getForumsUC
        self.getMyForumsUC = getMyForumsUC
        self.joinForumUC = joinForumUC
    }

    func onAppear() {
        Task { await load() }
    }

    func load() async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }
        do {
            // Fetch public forums
            let forumsResult = try await getForumsUC.execute(isPublic: true)
            self.forums = forumsResult
            
            // Try to fetch user's forums, but don't fail if this endpoint doesn't work
            do {
                let myResult = try await getMyForumsUC.execute()
                self.myForums = myResult
            } catch {
                self.myForums = []
            }
        } catch {
            self.errorMessage = RetroErrorMapper.map(error)
        }
    }

    func isMember(of forum: Forum) -> Bool {
        let result = myForums.contains(where: { $0.id == forum.id })
        return result
    }
    
    func joinForum(_ forumId: Int) async -> Bool {
        do {
            let success = try await joinForumUC.execute(forumId: forumId)
            if success {
                // Reload myForums to update the badge
                await load()
            }
            return success
        } catch {
            errorMessage = RetroErrorMapper.map(error)
            return false
        }
    }
}
