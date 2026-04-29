import UIKit

final class DSSpacerView: UIView {

    init(height: CGFloat? = nil) {
        super.init(frame: .zero)
        setContentHuggingPriority(.defaultLow, for: .vertical)
        setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        if let height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}
