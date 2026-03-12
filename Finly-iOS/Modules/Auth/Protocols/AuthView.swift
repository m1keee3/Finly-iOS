import Foundation

struct AuthViewState: Equatable {
    var isLoading: Bool = false
    var errorMessage: String?
    var showErrorAsAlert: Bool = false
    var emailError: String?
    var passwordError: String?
}

protocol AuthView: AnyObject {
    func render(_ state: AuthViewState)
}
