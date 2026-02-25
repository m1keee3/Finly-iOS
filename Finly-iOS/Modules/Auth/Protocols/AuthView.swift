import Foundation

struct AuthViewState: Equatable {
    var isLoading: Bool = false
    var loginButtonEnabled: Bool = false
    var errorMessage: String?
    var telegramBotLink: URL?
}

protocol AuthView: AnyObject {
    func render(_ state: AuthViewState)
}
