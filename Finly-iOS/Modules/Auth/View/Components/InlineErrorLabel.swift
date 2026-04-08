import UIKit

final class InlineErrorLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        font      = .systemFont(ofSize: 12)
        textColor = .systemRed
        numberOfLines = 0
        isHidden  = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    func show(_ message: String) {
        text     = message
        isHidden = false
    }

    func hide() {
        isHidden = true
        text     = nil
    }
}
