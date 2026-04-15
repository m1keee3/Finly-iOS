import Foundation

enum DashboardLoadingState: Equatable {
    case idle
    case loading
    case refreshing
    case content
    case empty
    case error(String)
}

struct DashboardViewState: Equatable {
    var loadingState: DashboardLoadingState = .idle
    var stats: DashboardStats?
    var cellViewModels: [PatternCellViewModel] = []
}

protocol DashboardView: AnyObject {
    func render(_ state: DashboardViewState)
}
