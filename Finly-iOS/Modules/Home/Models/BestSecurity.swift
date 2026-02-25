import Foundation

struct BestSecurity: Equatable {
    let ticker: String
    let probability: Double
    let priceChange: Double
    let chartPreview: [PricePoint]
}
