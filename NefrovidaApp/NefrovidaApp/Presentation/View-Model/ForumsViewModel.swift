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

    init(getForumsUC: GetForumsUseCase, getMyForumsUC: GetMyForumsUseCase) {
        self.getForumsUC = getForumsUC
        self.getMyForumsUC = getMyForumsUC
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
                print("DEBUG: Could not fetch user's forums (endpoint may not be implemented): \(error)")
                self.myForums = []
            }
        } catch {
            self.errorMessage = "No se pudieron cargar los foros: \(error.localizedDescription)"
        }
    }

    func isMember(of forum: Forum) -> Bool {
        return myForums.contains(where: { $0.id == forum.id })
    }
}
