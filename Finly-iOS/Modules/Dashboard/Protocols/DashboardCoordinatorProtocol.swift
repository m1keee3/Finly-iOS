import Foundation

protocol DashboardCoordinatorProtocol: AnyObject {
    func showPatternDetails(for patternId: String)
    func goBack()
}
