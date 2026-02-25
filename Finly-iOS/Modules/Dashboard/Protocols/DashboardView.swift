import Foundation

struct DashboardViewState: Equatable {
    var isLoading: Bool = true
    var stats: DashboardStats?
    var patterns: [PatternListItem] = []
    var filter: PatternsFilter
    var errorMessage: String?
    
    var filteredPatterns: [PatternListItem] {
        patterns
            .filter { $0.matchesCount >= filter.minMatches }
            .filter { filter.patternType == .all ? true : $0.patternType == filter.patternType }
            .sorted { lhs, rhs in
                switch filter.sortBy {
                case .probability:
                    return filter.sortAscending ? lhs.probability < rhs.probability : lhs.probability > rhs.probability
                case .matches:
                    return filter.sortAscending ? lhs.matchesCount < rhs.matchesCount : lhs.matchesCount > rhs.matchesCount
                case .priceChange:
                    return filter.sortAscending ? lhs.priceChange < rhs.priceChange : lhs.priceChange > rhs.priceChange
                }
            }
    }
    
    init(filter: PatternsFilter = PatternsFilter()) {
        self.filter = filter
    }
}

protocol DashboardView: AnyObject {
    func render(_ state: DashboardViewState)
}
