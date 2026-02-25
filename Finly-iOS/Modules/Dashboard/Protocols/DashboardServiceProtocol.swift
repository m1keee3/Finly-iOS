import Foundation

protocol DashboardServiceProtocol {
    func fetchStats() async throws -> DashboardStats
    func fetchPatterns(filter: PatternsFilter, page: Int, pageSize: Int) async throws -> [PatternListItem]
}
