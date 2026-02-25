import Foundation

struct ScannerViewState: Equatable {
    var isLoading: Bool = false
    var isScanning: Bool = false

    var availableSecurities: [Security] = []
    var selectedSecurity: Security?
    var chartSegment: ChartSegment?
    
    var patternParams: CandlePatternParams
    var selectedTargetSecurities: Set<String> = []
    var allSecuritiesSelected: Bool = false
    
    var scanResults: [ScanResult] = []
    var errorMessage: String?
    
    var canStartScan: Bool {
        !isScanning &&
        selectedSecurity != nil &&
        chartSegment?.isValid == true &&
        !selectedTargetSecurities.isEmpty
    }
    
    var selectedSecuritiesCount: Int {
        allSecuritiesSelected ? availableSecurities.count : selectedTargetSecurities.count
    }
    
    init(patternParams: CandlePatternParams = CandlePatternParams()) {
        self.patternParams = patternParams
    }
}

protocol ScannerView: AnyObject {
    func render(_ state: ScannerViewState)
}
