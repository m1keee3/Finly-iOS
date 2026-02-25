import Foundation

struct CandlePatternParams: Equatable {
    var tailLength: Double = 5.0
    var bodyTolerancePercent: Double = 0.1
    var shadowTolerancePercent: Double = 0.2
    var searchFromDate: Date
    var searchToDate: Date
    var statsDays: Int = 30
    
    init() {
        let calendar = Calendar.current
        let today = Date()
        self.searchToDate = today
        self.searchFromDate = calendar.date(byAdding: .year, value: -10, to: today) ?? today
    }
    
    var searchRangeFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return "\(formatter.string(from: searchFromDate)) → \(formatter.string(from: searchToDate))"
    }
}
