import Foundation

struct PatternCellViewModel: Equatable, Hashable {
    let id: String
    let title: String
    let subtitle: String?
    let rightText: String?
    let detailText: String?

    init(from item: PatternListItem) {
        id = item.id
        title = item.ticker
        subtitle = "\(item.companyCode) · \(item.patternType.displayName)"
        rightText = item.probabilityPercent
        detailText = item.priceChangeFormatted
    }
}
