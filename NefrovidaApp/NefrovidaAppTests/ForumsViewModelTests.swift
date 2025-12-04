import XCTest
@testable import NefrovidaApp

final class ForumsViewModelTests: XCTestCase {

    func test_loadsForums_success() async {
        let repo = MockForumRepository()
        let getForums = GetForumsUseCase(repository: repo)
        let getMy = GetMyForumsUseCase(repository: repo)
        let vm = ForumsViewModel(getForumsUC: getForums, getMyForumsUC: getMy)

        await vm.load()

        XCTAssertFalse(vm.forums.isEmpty, "Expected forums to be loaded")
        XCTAssertEqual(vm.myForums.first?.id, 1)
    }
}
