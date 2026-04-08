import UIKit

final class TextFieldContainerView: UIView {

    enum Highlight {
        case normal, focused, error
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor    = .secondarySystemBackground
        layer.cornerRadius = 12
        layer.borderWidth  = 1
        isUserInteractionEnabled = true
        setHighlight(.normal)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    func addTextField(_ textField: UITextField) {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isUserInteractionEnabled = true
        addSubview(textField)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }

    func setHighlight(_ highlight: Highlight) {
        switch highlight {
        case .normal:
            layer.borderColor = UIColor.separator.cgColor
        case .focused:
            layer.borderColor = UIColor.systemBlue.cgColor
        case .error:
            layer.borderColor = UIColor.systemRed.cgColor
        }
    }
}
