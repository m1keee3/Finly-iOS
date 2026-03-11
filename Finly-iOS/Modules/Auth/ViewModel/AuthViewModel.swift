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

            } catch {
                setLoading(false)
                state.errorMessage = AuthError.unknown(error.localizedDescription).errorDescription
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

            } catch {
                setLoading(false)
                state.errorMessage = error.localizedDescription
            }
        }
    }

    private func setLoading(_ isLoading: Bool) {
        state.isLoading = isLoading
        state.loginButtonEnabled = !isLoading
        if isLoading {
            state.errorMessage = nil
        }
    }
}
