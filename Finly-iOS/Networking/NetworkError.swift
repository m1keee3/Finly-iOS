import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case badStatusCode(Int)
    case noData
    case decodingFailed(Error)
    case cancelled
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Некорректный URL"
        case .badStatusCode(let code):
            return "Ошибка сервера: \(code)"
        case .noData:
            return "Сервер не вернул данные"
        case .decodingFailed:
            return "Ошибка разбора данных"
        case .cancelled:
            return "Запрос отменён"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
