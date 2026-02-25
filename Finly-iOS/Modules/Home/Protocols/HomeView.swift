import Foundation

struct HomeViewState: Equatable {
    var isLoading: Bool = true
    var bestSecurity: BestSecurity?
    var errorMessage: String?

    var showSkeleton: Bool { isLoading && bestSecurity == nil }
    var showContent: Bool { !isLoading && bestSecurity != nil }
    var showError: Bool { !isLoading && errorMessage != nil }
}

protocol HomeView: AnyObject {
    func render(_ state: HomeViewState)
}
