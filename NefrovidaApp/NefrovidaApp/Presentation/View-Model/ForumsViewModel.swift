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
            async let forumsList = try getForumsUC.execute(isPublic: true)
            async let myList = try getMyForumsUC.execute()
            let (forumsResult, myResult) = try await (forumsList, myList)
            self.forums = forumsResult
            self.myForums = myResult
        } catch {
            self.errorMessage = "No se pudieron cargar los foros." 
        }
    }

    func isMember(of forum: Forum) -> Bool {
        return myForums.contains(where: { $0.id == forum.id })
    }
}
