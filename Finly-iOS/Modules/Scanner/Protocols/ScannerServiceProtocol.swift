import Foundation

protocol ScannerServiceProtocol {
    func fetchAvailableSecurities() async throws -> [Security]
    func fetchChartData(securityId: String, from: Date, to: Date) async throws -> [PricePoint]
    func startScan(_ request: ScanRequest) async throws -> [ScanResult]
}
