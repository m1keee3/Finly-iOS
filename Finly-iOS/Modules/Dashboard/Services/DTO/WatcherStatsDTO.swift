import Foundation

// GET /watcher/stats возвращает JSON-массив верхнего уровня: [{...}, {...}]
// StatsResponseDTO — запасной вариант на случай если формат изменится на {"items":[...]}

struct StatsResponseDTO: Decodable {
    let items: [StatsItemDTO]
}

struct StatsItemDTO: Decodable {
    let segment: SegmentDTO
    let patternType: String   // "candle" / "chart"; snake_case → camelCase через keyDecodingStrategy
    let totalMatches: Int
    let priceChange: Double
    let probability: Double
}

struct SegmentDTO: Decodable {
    let ticker: String
    let from: Date
    let to: Date
}
