import UIKit

final class PatternTableViewCell: UITableViewCell {

    static let reuseIdentifier = "PatternTableViewCell"

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let probabilityLabel = UILabel()
    private let priceChangeLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        probabilityLabel.text = nil
        priceChangeLabel.text = nil
        probabilityLabel.textColor = .secondaryLabel
    }

    func configure(with viewModel: PatternCellViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        probabilityLabel.text = viewModel.rightText
        priceChangeLabel.text = viewModel.detailText

        if let detail = viewModel.detailText {
            priceChangeLabel.textColor = detail.hasPrefix("+") ? .systemGreen : .systemRed
        }
    }

    private func setupLayout() {
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .label

        subtitleLabel.font = .systemFont(ofSize: 13)
        subtitleLabel.textColor = .secondaryLabel

        probabilityLabel.font = .systemFont(ofSize: 15, weight: .medium)
        probabilityLabel.textColor = .secondaryLabel
        probabilityLabel.textAlignment = .right
        probabilityLabel.setContentHuggingPriority(.required, for: .horizontal)
        probabilityLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        priceChangeLabel.font = .systemFont(ofSize: 13)
        priceChangeLabel.textAlignment = .right
        priceChangeLabel.setContentHuggingPriority(.required, for: .horizontal)
        priceChangeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        let leftStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        leftStack.axis = .vertical
        leftStack.spacing = 3

        let rightStack = UIStackView(arrangedSubviews: [probabilityLabel, priceChangeLabel])
        rightStack.axis = .vertical
        rightStack.spacing = 3
        rightStack.alignment = .trailing

        let row = UIStackView(arrangedSubviews: [leftStack, rightStack])
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = 8
        row.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(row)
        NSLayoutConstraint.activate([
            row.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            row.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            row.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            row.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
}
