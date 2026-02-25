import Foundation

protocol AuthServiceProtocol {
    func loginWithTelegram(telegramId: String) async throws -> UserSession
    func loginWithEmail(email: String, password: String) async throws -> UserSession
    func register(email: String, password: String) async throws -> UserSession
}
