import UIKit

enum DSButtonStyle {
    case primary
    case secondary
    case plain
}

final class DSButton: UIButton {

    private let buttonStyle: DSButtonStyle
    private let buttonTitle: String
    private lazy var spinner: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.hidesWhenStopped = true
        ai.color = buttonStyle == .primary ? .white : DS.Colors.accent
        return ai
    }()

    init(style: DSButtonStyle, title: String) {
        self.buttonStyle = style
        self.buttonTitle = title
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        applyStyle()
        setupSpinner()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    func setLoading(_ loading: Bool) {
        if loading {
            configuration?.title = ""
            spinner.startAnimating()
        } else {
            spinner.stopAnimating()
            configuration?.title = buttonTitle
        }
    }

    private func applyStyle() {
        switch buttonStyle {
        case .primary:
            var config = UIButton.Configuration.filled()
            config.title = buttonTitle
            config.baseBackgroundColor = DS.Colors.accent
            config.cornerStyle = .large
            config.buttonSize = .large
            configuration = config

        case .secondary:
            var config = UIButton.Configuration.tinted()
            config.title = buttonTitle
            config.cornerStyle = .large
            config.buttonSize = .large
            configuration = config

        case .plain:
            var config = UIButton.Configuration.plain()
            config.title = buttonTitle
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attrs in
                var updated = attrs
                updated.font = DS.Typography.bodyMedium()
                return updated
            }
            configuration = config
        }
    }

    private func setupSpinner() {
        addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
