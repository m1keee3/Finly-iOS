import Foundation

protocol ScannerViewModelProtocol {
    func didLoad()
    
    func didSelectSecurity(_ securityId: String?)
    func didToggleTargetSecurity(_ securityId: String, selected: Bool)
    func didToggleAllSecurities(_ selected: Bool)
    
    func didUpdateChartSegment(start: Date, end: Date)
    
    func didUpdateTailLength(_ value: Double)
    func didUpdateBodyTolerance(_ value: Double)
    func didUpdateShadowTolerance(_ value: Double)
    func didUpdateSearchFromDate(_ date: Date)
    func didUpdateSearchToDate(_ date: Date)
    func didUpdateStatsDays(_ days: Int)
    
    func didTapStartScan()
    func didTapResetParameters()
    
    func didSelectScanResult(_ resultId: String)
    
    func didTapRetry()
}
