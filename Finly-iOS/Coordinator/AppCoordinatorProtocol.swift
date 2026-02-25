import Foundation

protocol AppCoordinatorProtocol: AnyObject {
    func start()
    func showAuth()
    func showHome(with session: UserSession)
    func logout()
}
