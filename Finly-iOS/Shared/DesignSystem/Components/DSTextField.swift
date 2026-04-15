import UIKit

struct FormFieldConfig {
    let title: String
    let placeholder: String
    let keyboardType: UIKeyboardType
    let isSecure: Bool
    let returnKeyType: UIReturnKeyType
    let accessibilityIdentifier: String
}

enum TextFieldHighlight {
    case normal, focused, error
}

final class DSTextField: UIView {

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = DS.Typography.caption()
        l.textColor = DS.Colors.labelSecondary
        return l
    }()

    private let containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = DS.Colors.backgroundSecondary
        v.layer.cornerRadius = DS.CornerRadius.field
        v.layer.borderWidth = 1
        return v
    }()

    private let _textField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = DS.Typography.bodyLarge()
        return tf
    }()

    private let errorLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = DS.Typography.caption()
        l.textColor = DS.Colors.destructive
        l.isHidden = true
        l.numberOfLines = 0
        return l
    }()

    var textField: UITextField { _textField }
    var text: String? { _textField.text }

    var isEnabled: Bool = true {
        didSet {
            _textField.isEnabled = isEnabled
            alpha = isEnabled ? 1.0 : 0.5
        }
    }

    init(config: FormFieldConfig) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = config.title
        _textField.placeholder = config.placeholder
        _textField.keyboardType = config.keyboardType
        _textField.isSecureTextEntry = config.isSecure
        _textField.returnKeyType = config.returnKeyType
        _textField.autocapitalizationType = config.isSecure ? .none : .none
        _textField.autocorrectionType = .no
        _textField.isUserInteractionEnabled = true
        _textField.accessibilityIdentifier = config.accessibilityIdentifier

        setupLayout()
        setHighlight(.normal)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    func setHighlight(_ highlight: TextFieldHighlight) {
        switch highlight {
        case .normal:
            containerView.layer.borderColor = DS.Colors.separator.cgColor
        case .focused:
            containerView.layer.borderColor = DS.Colors.accent.cgColor
        case .error:
            containerView.layer.borderColor = DS.Colors.destructive.cgColor
        }
    }

    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        setHighlight(.error)
    }

    func clearError() {
        errorLabel.text = nil
        errorLabel.isHidden = true
        setHighlight(.normal)
    }

    private func setupLayout() {
        addSubview(titleLabel)
        addSubview(containerView)
        containerView.addSubview(_textField)
        addSubview(errorLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            containerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: DS.Spacing.xs),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: DS.Spacing.fieldHeight),

            _textField.topAnchor.constraint(equalTo: containerView.topAnchor),
            _textField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            _textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: DS.Spacing.l),
            _textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -DS.Spacing.l),

            errorLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: DS.Spacing.xs),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DS.Spacing.xs),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
