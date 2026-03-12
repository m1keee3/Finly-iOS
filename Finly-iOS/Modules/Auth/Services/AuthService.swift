import Foundation

final class AuthService: AuthServiceProtocol {

    private enum ValidCredentials {
        static let email    = "user@finly.app"
        static let password = "user123"
    }

    private let mockUserId = "usr_001"
    private let mockToken  = "mock_token_123"

    func loginWithTelegram(telegramId: String) async throws -> UserSession {
        return UserSession(userId: mockUserId, token: mockToken)
    }

    func loginWithEmail(email: String, password: String) async throws -> UserSession {
        try await Task.sleep(for: .seconds(1))

        guard !email.isEmpty, !password.isEmpty else {
            throw AuthError.emptyFields
        }

        guard email == ValidCredentials.email,
              password == ValidCredentials.password else {
            throw AuthError.invalidCredentials
        }

        return UserSession(userId: mockUserId, token: mockToken)
    }

    func register(email: String, password: String) async throws -> UserSession {
        throw AuthError.unknown("Регистрация пока недоступна")
    }
}


