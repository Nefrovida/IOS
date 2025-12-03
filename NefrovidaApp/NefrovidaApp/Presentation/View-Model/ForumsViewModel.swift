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
        if forums.isEmpty {
            Task { await load() }
        }
    }
    
    func refresh() {
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
                print("DEBUG: Fetching my forums...")
                let myResult = try await getMyForumsUC.execute()
                print("DEBUG: Fetched \(myResult.count) joined forums")
                self.myForums = myResult
                
                // Filter out joined forums from the public list
                self.forums = forumsResult.filter { publicForum in
                    !myResult.contains(where: { $0.id == publicForum.id })
                }
            } catch {
                print("DEBUG: Failed to fetch my forums: \(error)")
                self.myForums = []
                self.forums = forumsResult
            }
        } catch {
            self.errorMessage = "No se pudieron cargar los foros: \(error.localizedDescription)"
        }
    }

    func isMember(of forum: Forum) -> Bool {
        let result = myForums.contains(where: { $0.id == forum.id })
        return result
    }
    
    func joinForum(_ forumId: Int) async -> Bool {
        print("DEBUG: joinForum called for id: \(forumId)")
        do {
            let success = try await joinForumUC.execute(forumId: forumId)
            print("DEBUG: joinForumUC success: \(success)")
            if success {
                // Optimistic update: add to myForums immediately and remove from forums
                if let joinedForum = forums.first(where: { $0.id == forumId }) {
                    if !myForums.contains(where: { $0.id == forumId }) {
                        print("DEBUG: Adding to myForums optimistically")
                        myForums.append(joinedForum)
                        // Remove from public list
                        forums.removeAll(where: { $0.id == forumId })
                    } else {
                        print("DEBUG: Already in myForums")
                    }
                } else {
                    print("DEBUG: Forum not found in public list")
                }
                
                // Reload myForums to update the badge and confirm with server
                // Reload myForums to update the badge and confirm with server
                // await load() // Commented out to prevent race condition where server hasn't updated yet
            }
            return success
        } catch {
            print("DEBUG: joinForum failed with error: \(error)")
            errorMessage = "No se pudo unir al foro: \(error.localizedDescription)"
            return false
        }
    }
}
