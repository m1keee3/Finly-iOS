import UIKit

protocol BDUIMapperProtocol {
    func map(_ node: BDUINode) -> UIView
}

protocol ComponentBuilder {
    associatedtype Config: Decodable
    func build(config: Config, subviews: [UIView]) -> UIView
}
