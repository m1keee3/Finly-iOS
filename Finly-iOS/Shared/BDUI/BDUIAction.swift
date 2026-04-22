import Foundation

enum BDUIAction: Decodable {
    case print(message: String)

    private enum CodingKeys: String, CodingKey {
        case type, message
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case "print":
            let message = try container.decode(String.self, forKey: .message)
            self = .print(message: message)
        default:
            throw DecodingError.dataCorruptedError(
                forKey: .type, in: container,
                debugDescription: "Unknown BDUIAction type: \(type)"
            )
        }
    }
}
