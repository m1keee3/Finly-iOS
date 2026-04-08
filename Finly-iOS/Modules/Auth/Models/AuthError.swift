import Foundation

enum AuthError: Error, LocalizedError {
    case invalidCredentials
    case emptyFields
    case invalidEmailFormat
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Неверный email или пароль"
        case .emptyFields:
            return "Заполните все поля"
        case .invalidEmailFormat:
            return "Введите корректный email"
        case .unknown(let message):
            return message
        }
    }
}
