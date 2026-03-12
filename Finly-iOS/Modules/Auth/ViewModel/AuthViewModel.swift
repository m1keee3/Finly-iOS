import Foundation

final class AuthViewModel: AuthViewModelProtocol {

    weak var view: AuthView?
    private let authService: AuthServiceProtocol
    private weak var coordinator: AuthCoordinatorProtocol?

    private var state = AuthViewState() {
        didSet {
            guard state != oldValue else { return }
            view?.render(state)
        }
    }

    init(
        authService: AuthServiceProtocol,
        coordinator: AuthCoordinatorProtocol
    ) {
        self.authService = authService
        self.coordinator = coordinator
    }

    func didTapLoginWithTelegram() {
        coordinator?.openTelegramBot()
    }

    func didTapLoginWithEmail(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            state.errorMessage = AuthError.emptyFields.errorDescription
            state.showErrorAsAlert = false
            return
        }

        Task { @MainActor in
            setLoading(true)

            do {
                let session = try await authService.loginWithEmail(
                    email: email,
                    password: password
                )
                setLoading(false)
                coordinator?.didFinishAuth(with: session)

            } catch let error as AuthError {
                setLoading(false)
                state.errorMessage = error.errorDescription
                state.showErrorAsAlert = false

            } catch {
                setLoading(false)
                state.errorMessage = error.localizedDescription
                state.showErrorAsAlert = false
            }
        }
    }

    func didTapRegister() {
        Task { @MainActor in
            setLoading(true)

            do {
                let session = try await authService.register(
                    email: "",
                    password: ""
                )
                setLoading(false)
                coordinator?.didFinishAuth(with: session)

            } catch let error as AuthError {
                setLoading(false)
                state.errorMessage = error.errorDescription
                state.showErrorAsAlert = true

            } catch {
                setLoading(false)
                state.errorMessage = error.localizedDescription
                state.showErrorAsAlert = true
            }
        }
    }

    func didChangeEmail(_ email: String) {
        state.errorMessage = nil
        state.showErrorAsAlert = false
        
        guard !email.isEmpty else {
            state.emailError = nil
            return
        }
        state.emailError = isValidEmail(email)
            ? nil
            : "Введите корректный email"
    }

    func didChangePassword(_ password: String) {
        state.errorMessage = nil
        state.showErrorAsAlert = false
        
        guard !password.isEmpty else {
            state.passwordError = nil
            return
        }
        state.passwordError = password.count >= 6
            ? nil
            : "Минимум 6 символов"
    }

    func didShowAlert() {
        state.errorMessage = nil
        state.showErrorAsAlert = false
    }

    private func setLoading(_ isLoading: Bool) {
        state.isLoading = isLoading
        if isLoading {
            state.errorMessage = nil
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let regex = #"^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$"#
        return email.range(of: regex, options: .regularExpression) != nil
    }
}
