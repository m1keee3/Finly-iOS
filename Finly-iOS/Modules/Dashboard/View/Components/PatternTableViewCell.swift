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
        probabilityLabel.textColor = DS.Colors.labelSecondary
    }

    func configure(with viewModel: PatternCellViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        probabilityLabel.text = viewModel.rightText
        priceChangeLabel.text = viewModel.detailText

        if let detail = viewModel.detailText {
            priceChangeLabel.textColor = detail.hasPrefix("+") ? DS.Colors.positive : DS.Colors.destructive
        }
    }

    private func setupLayout() {
        titleLabel.apply(.listTitle)
        subtitleLabel.apply(.listSubtitle)
        probabilityLabel.apply(.listMetric)
        probabilityLabel.textAlignment = .right
        probabilityLabel.setContentHuggingPriority(.required, for: .horizontal)
        probabilityLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        priceChangeLabel.font = DS.Typography.bodySmall()
        priceChangeLabel.textAlignment = .right
        priceChangeLabel.setContentHuggingPriority(.required, for: .horizontal)
        priceChangeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        let leftStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        leftStack.axis = .vertical
        leftStack.spacing = DS.Spacing.xxs

        let rightStack = UIStackView(arrangedSubviews: [probabilityLabel, priceChangeLabel])
        rightStack.axis = .vertical
        rightStack.spacing = DS.Spacing.xxs
        rightStack.alignment = .trailing

        let row = UIStackView(arrangedSubviews: [leftStack, rightStack])
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = DS.Spacing.s
        row.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(row)
        NSLayoutConstraint.activate([
            row.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DS.Spacing.m),
            row.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DS.Spacing.m),
            row.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DS.Spacing.l),
            row.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DS.Spacing.l),
        ])
    }
}
