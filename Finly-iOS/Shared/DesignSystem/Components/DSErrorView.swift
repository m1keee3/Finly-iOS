import UIKit

final class DSErrorView: UIView {

    struct Config {
        var message: String
    }

    var onRetry: (() -> Void)?

    private let messageLabel: UILabel = {
        let l = UILabel()
        l.apply(.errorBody)
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()

    private lazy var retryButton: DSButton = {
        let b = DSButton()
        b.configure(DSButton.Config(style: .plain, title: "Повторить"))
        return b
    }()

    private lazy var stack: UIStackView = {
        let s = UIStackView(arrangedSubviews: [messageLabel, retryButton])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .vertical
        s.alignment = .center
        s.spacing = DS.Spacing.m
        return s
    }()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    func configure(_ config: Config) {
        messageLabel.text = config.message
    }

    @objc private func retryTapped() {
        onRetry?()
    }
}
