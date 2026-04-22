import UIKit

final class DSCardView: UIView {

    struct Config {
        let backgroundColor: UIColor
        let padding: CGFloat
        let cornerRadius: CGFloat

        init(
            backgroundColor: UIColor = DS.Colors.backgroundSecondary,
            padding: CGFloat = DS.Spacing.m,
            cornerRadius: CGFloat = DS.CornerRadius.field
        ) {
            self.backgroundColor = backgroundColor
            self.padding = padding
            self.cornerRadius = cornerRadius
        }
    }

    private let innerStack: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    init(config: Config, subviews: [UIView]) {
        super.init(frame: .zero)

        backgroundColor = config.backgroundColor
        layer.cornerRadius = config.cornerRadius
        clipsToBounds = true

        subviews.forEach { innerStack.addArrangedSubview($0) }
        addSubview(innerStack)

        let p = config.padding
        NSLayoutConstraint.activate([
            innerStack.topAnchor.constraint(equalTo: topAnchor, constant: p),
            innerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: p),
            innerStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -p),
            innerStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -p),
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}
