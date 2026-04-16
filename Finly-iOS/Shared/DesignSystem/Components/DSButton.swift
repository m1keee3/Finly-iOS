import UIKit

final class DSButton: UIButton {

    enum Style {
        case primary
        case secondary
        case plain
    }

    struct Config {
        var style: Style
        var title: String
        var isEnabled: Bool = true
    }

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    func configure(_ config: Config) {
        switch config.style {
        case .primary:
            var buttonConfig = UIButton.Configuration.filled()
            buttonConfig.title = config.title
            buttonConfig.baseBackgroundColor = DS.Colors.accent
            buttonConfig.cornerStyle = .large
            buttonConfig.buttonSize = .large
            configuration = buttonConfig

        case .secondary:
            var buttonConfig = UIButton.Configuration.tinted()
            buttonConfig.title = config.title
            buttonConfig.cornerStyle = .large
            buttonConfig.buttonSize = .large
            configuration = buttonConfig

        case .plain:
            var buttonConfig = UIButton.Configuration.plain()
            buttonConfig.title = config.title
            buttonConfig.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attrs in
                var updated = attrs
                updated.font = DS.Typography.bodyMedium()
                return updated
            }
            configuration = buttonConfig
        }

        isUserInteractionEnabled = config.isEnabled
        alpha = config.isEnabled ? 1.0 : 0.5
    }
}
