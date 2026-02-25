import Foundation

struct DashboardStats: Equatable {
    let activePatterns: Int
    let bestTicker: String
    let bestProbability: Double
    let avgProbability: Double
    let avgPriceChange: Double
}
