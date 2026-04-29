import UIKit

final class DashboardStatsHeaderView: UIView {

    private let bestTickerLabel = UILabel()
    private let probabilityLabel = UILabel()
    private let activePatternsLabel = UILabel()
    private let avgPriceChangeLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    func configure(with stats: DashboardStats?) {
        guard let stats else {
            isHidden = true
            return
        }
        isHidden = false
        bestTickerLabel.text = "Лучший тикер: \(stats.bestTicker)"
        probabilityLabel.text = "Вероятность: \(Int(stats.bestProbability * 100))%"
        activePatternsLabel.text = "Паттернов: \(stats.activePatterns)"
        let avgChange = String(format: "%.2f", stats.avgPriceChange * 100)
        avgPriceChangeLabel.text = "Ср. изм. цены: \(avgChange)%"
    }

    private func setupLayout() {
        backgroundColor = DS.Colors.backgroundSecondary

        bestTickerLabel.apply(.sectionHeader)
        probabilityLabel.apply(.sectionMeta)
        activePatternsLabel.apply(.sectionMeta)
        avgPriceChangeLabel.apply(.sectionMeta)

        let topRow = UIStackView(arrangedSubviews: [bestTickerLabel, probabilityLabel])
        topRow.axis = .horizontal
        topRow.spacing = DS.Spacing.m

        let bottomRow = UIStackView(arrangedSubviews: [activePatternsLabel, avgPriceChangeLabel])
        bottomRow.axis = .horizontal
        bottomRow.spacing = DS.Spacing.m

        let stack = UIStackView(arrangedSubviews: [topRow, bottomRow])
        stack.axis = .vertical
        stack.spacing = DS.Spacing.xs
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: DS.Spacing.m),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -DS.Spacing.m),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DS.Spacing.l),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DS.Spacing.l),
        ])
    }
}
