import Foundation

enum PatternsSortBy: String, Equatable, CaseIterable {
    case probability = "Вероятность"
    case matches = "Совпадения"
    case priceChange = "Изм. цены"
}

struct PatternsFilter: Equatable {
    var minMatches: Int = 5
    var minMatchesRange: ClosedRange<Int> = 0...200
    var deviationFromAvg: Double = 0.0
    var patternType: PatternType = .all
    var sortBy: PatternsSortBy = .probability
    var sortAscending: Bool = false
}
