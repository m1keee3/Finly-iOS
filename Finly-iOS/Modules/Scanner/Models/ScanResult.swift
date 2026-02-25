import Foundation

struct ScanResult: Identifiable, Equatable {
    let id: String
    let matchedSecurityId: String
    let matchedSecuritySymbol: String
    let matchedSegment: ChartSegment
    let similarityScore: Double
    let expectedPriceChange: Double
    
    var similarityPercent: String {
        "\(Int(similarityScore * 100))%"
    }
    
    var priceChangeFormatted: String {
        let sign = expectedPriceChange >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.2f", expectedPriceChange))%"
    }
}
