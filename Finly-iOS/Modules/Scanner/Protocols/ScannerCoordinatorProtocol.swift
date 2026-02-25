import Foundation

protocol ScannerCoordinatorProtocol: AnyObject {
    func showScanResults(_ results: [ScanResult])
    func showScanResultDetails(_ result: ScanResult)
    func goBack()
}
