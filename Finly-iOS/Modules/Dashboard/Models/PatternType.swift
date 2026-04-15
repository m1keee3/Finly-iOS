import Foundation

enum PatternType: String, Equatable, CaseIterable {
    case candle = "candle"
    case chart = "chart"
    case all = "all"

    var displayName: String {
        switch self {
        case .candle: return "Свеча"
        case .chart:  return "График"
        case .all:    return "Все"
        }
    }
}
