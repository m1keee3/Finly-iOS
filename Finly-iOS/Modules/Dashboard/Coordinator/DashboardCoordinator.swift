import UIKit

final class DashboardCoordinator: DashboardCoordinatorProtocol {

    private let navigationController: UINavigationController
    private let session: UserSession

    init(navigationController: UINavigationController, session: UserSession) {
        self.navigationController = navigationController
        self.session = session
    }

    func start() {
        let networkClient = NetworkClient()
        let service = DashboardService(networkClient: networkClient)
        let viewModel = DashboardViewModel(service: service, coordinator: self)
        let viewController = DashboardStubViewController(viewModel: viewModel)
        viewModel.view = viewController
        navigationController.pushViewController(viewController, animated: true)
    }


    func showPatternDetails(for patternId: String) {
    }

    func goBack() {
        navigationController.popViewController(animated: true)
    }
}
