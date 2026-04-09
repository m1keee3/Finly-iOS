import UIKit

final class AuthCoordinator: AuthCoordinatorProtocol {

    private let navigationController: UINavigationController
    private let authService: AuthServiceProtocol

    private let telegramBotURL = URL(string: "https://t.me/finly_bot")!


    init(
        navigationController: UINavigationController,
        authService: AuthServiceProtocol = AuthService()
    ) {
        self.navigationController = navigationController
        self.authService = authService
    }


    func start() {
        let viewModel = AuthViewModel(
            authService: authService,
            coordinator: self
        )
        let viewController = LoginViewController(viewModel: viewModel)
        viewModel.view = viewController
        navigationController.setViewControllers([viewController], animated: false)
    }


    func didFinishAuth(with session: UserSession) {
        let stubVC = HomeStubViewController(session: session)

        stubVC.onDashboardTap = { [weak self] in
            guard let self else { return }
            let coordinator = DashboardCoordinator(
                navigationController: self.navigationController,
                session: session
            )
            coordinator.start()
        }

        navigationController.setViewControllers([stubVC], animated: true)
    }

    func openTelegramBot() {
        UIApplication.shared.open(telegramBotURL)
    }
}
