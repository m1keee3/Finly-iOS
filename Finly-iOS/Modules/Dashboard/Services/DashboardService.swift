import Foundation

final class DashboardService: DashboardServiceProtocol {

    private let networkClient: NetworkClientProtocol
    private let baseURL: String

    private var cachedItems: [StatsItemDTO]?

    init(
        networkClient: NetworkClientProtocol = NetworkClient(),
        baseURL: String = "http://localhost:8090"
    ) {
        self.networkClient = networkClient
        self.baseURL = baseURL
    }

    func fetchStats() async throws -> DashboardStats {
        let items = try await loadItems()
        return makeStats(from: items)
    }

    func fetchPatterns(filter: PatternsFilter, page: Int, pageSize: Int) async throws -> [PatternListItem] {
        let items = try await loadItems()
        let all = items.map { mapItem($0) }

        let start = page * pageSize
        guard start < all.count else { return [] }
        let end = min(start + pageSize, all.count)
        return Array(all[start..<end])
    }

    func invalidateCache() {
        cachedItems = nil
    }

    private func loadItems() async throws -> [StatsItemDTO] {
        if let cached = cachedItems { return cached }

        let items: [StatsItemDTO]
        do {
            items = try await networkClient.get(baseURL + "/watcher/stats")
        } catch NetworkError.decodingFailed {
            let wrapped: StatsResponseDTO = try await networkClient.get(baseURL + "/watcher/stats")
            items = wrapped.items
        }

        cachedItems = items
        return items
    }

    private func makeStats(from items: [StatsItemDTO]) -> DashboardStats {
        guard !items.isEmpty else {
            return DashboardStats(
                activePatterns: 0,
                bestTicker: "—",
                bestProbability: 0,
                avgProbability: 0,
                avgPriceChange: 0
            )
        }
        let best = items.max(by: { $0.probability < $1.probability })!
        let avgProbability = items.map(\.probability).reduce(0, +) / Double(items.count)
        let avgPriceChange = items.map(\.priceChange).reduce(0, +) / Double(items.count)
        return DashboardStats(
            activePatterns: items.count,
            bestTicker: best.segment.ticker,
            bestProbability: best.probability,
            avgProbability: avgProbability,
            avgPriceChange: avgPriceChange
        )
    }

    private func mapItem(_ dto: StatsItemDTO) -> PatternListItem {
        let id = "\(dto.segment.ticker)_\(dto.patternType)_\(dto.segment.from.timeIntervalSince1970)"

        let patternType: PatternType
        switch dto.patternType {
        case "candle": patternType = .candle
        case "chart":  patternType = .chart
        default:       patternType = .candle
        }

        return PatternListItem(
            id: id,
            ticker: dto.segment.ticker,
            companyCode: dto.segment.ticker,
            patternType: patternType,
            periodStart: dto.segment.from,
            periodEnd: dto.segment.to,
            matchesCount: dto.totalMatches,
            priceChange: dto.priceChange,
            probability: dto.probability,
            chartSparkline: []
        )
    }
}
