import UIKit

final class DividerView: UIView {

    init(text: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupWith(text: text)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    private func setupWith(text: String) {
        let leftLine  = makeLine()
        let rightLine = makeLine()

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text      = text
        label.font      = .systemFont(ofSize: 13)
        label.textColor = .tertiaryLabel

        [leftLine, label, rightLine].forEach { addSubview($0) }

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),

            leftLine.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            leftLine.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: -12),
            leftLine.heightAnchor.constraint(equalToConstant: 1),

            rightLine.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightLine.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 12),
            rightLine.heightAnchor.constraint(equalToConstant: 1),
        ])
    }

    private func makeLine() -> UIView {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .separator
        return v
    }
}
