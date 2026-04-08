import Foundation

protocol NetworkClientProtocol {
    func get<T: Decodable>(_ urlString: String) async throws -> T
}

final class NetworkClient: NetworkClientProtocol {

    private let session: URLSession
    private let decoder: JSONDecoder

    var useMockData: Bool = false
    private let mockBundle: Bundle

    init(session: URLSession = .shared, mockBundle: Bundle = .main) {
        self.session = session
        self.mockBundle = mockBundle

        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        d.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)

            let withFractional: ISO8601DateFormatter = {
                let f = ISO8601DateFormatter()
                f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                return f
            }()
            let standard: ISO8601DateFormatter = {
                let f = ISO8601DateFormatter()
                f.formatOptions = [.withInternetDateTime]
                return f
            }()

            if let date = withFractional.date(from: string) { return date }
            if let date = standard.date(from: string) { return date }

            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot decode date: \(string)"
            )
        }
        self.decoder = d
    }

    func get<T: Decodable>(_ urlString: String) async throws -> T {
        if useMockData {
            return try loadFromBundle(urlString)
        }
        return try await performRequest(urlString)
    }

    private func performRequest<T: Decodable>(_ urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(from: url)
        } catch let urlError as URLError where urlError.code == .cancelled {
            throw NetworkError.cancelled
        } catch {
            throw NetworkError.unknown(error)
        }

        if let http = response as? HTTPURLResponse,
           !(200..<300).contains(http.statusCode) {
            throw NetworkError.badStatusCode(http.statusCode)
        }

        guard !data.isEmpty else {
            throw NetworkError.noData
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }

    private func loadFromBundle<T: Decodable>(_ urlString: String) throws -> T {
        let name = URL(string: urlString)?.lastPathComponent ?? "mock"
        guard let url = mockBundle.url(forResource: name, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            throw NetworkError.noData
        }
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}
