import Foundation

protocol AuthViewModelProtocol {
    func didTapLoginWithTelegram()
    func didTapLoginWithEmail(email: String, password: String)
    func didTapRegister()
    func didChangeEmail(_ email: String)
    func didChangePassword(_ password: String)
    func didShowAlert()
}
