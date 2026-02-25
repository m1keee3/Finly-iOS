import Foundation

protocol BestSecurityServiceProtocol {
    func fetchBestSecurity() async throws -> BestSecurity
}
