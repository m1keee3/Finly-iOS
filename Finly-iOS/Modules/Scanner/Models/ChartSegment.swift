import Foundation

struct ChartSegment: Equatable {
    let securityId: String
    let startDate: Date
    let endDate: Date
    let dataPoints: [PricePoint]
    
    var daysCount: Int {
        Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
    }
    
    var isValid: Bool {
        daysCount > 0 && !dataPoints.isEmpty
    }
}
