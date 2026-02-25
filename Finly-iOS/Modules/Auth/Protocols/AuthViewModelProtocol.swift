import Foundation

protocol AuthViewModelProtocol {
    func didTapLoginWithTelegram()
    func didTapLoginWithEmail(email: String, password: String)
    func didTapRegister()
}
