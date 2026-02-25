import Foundation

struct ScanRequest: Equatable {
    let securityId: String
    let segment: ChartSegment
    let targetSecurityIds: [String]
    let params: CandlePatternParams
    
    var isValid: Bool {
        !securityId.isEmpty &&
        segment.isValid &&
        !targetSecurityIds.isEmpty
    }
}
