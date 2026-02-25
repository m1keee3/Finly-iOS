import Foundation

protocol AuthCoordinatorProtocol: AnyObject {
    func didFinishAuth(with session: UserSession)
    func openTelegramBot()
}
