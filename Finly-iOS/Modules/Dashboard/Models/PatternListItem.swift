import Foundation

struct PatternListItem: Identifiable, Equatable {
    let id: String
    let ticker: String
    let companyCode: String
    let patternType: PatternType
    let periodStart: Date
    let periodEnd: Date
    let matchesCount: Int
    let priceChange: Double
    let probability: Double
    let chartSparkline: [Double]
    
    var periodFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return "\(formatter.string(from: periodStart)) → \(formatter.string(from: periodEnd))"
    }
    
    var probabilityPercent: String {
        "\(Int(probability * 100))%"
    }
    
    var priceChangeFormatted: String {
        let sign = priceChange >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.2f", priceChange * 100))%"
    }
}
