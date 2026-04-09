import Foundation

struct StatsItemDTO: Decodable {
    let segment: SegmentDTO
    let patternType: String
    let totalMatches: Int
    let priceChange: Double
    let probability: Double
}

struct SegmentDTO: Decodable {
    let ticker: String
    let from: Date
    let to: Date
}
