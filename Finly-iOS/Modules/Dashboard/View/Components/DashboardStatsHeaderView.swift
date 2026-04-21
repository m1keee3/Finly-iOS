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
        backgroundColor = .secondarySystemBackground

        bestTickerLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        bestTickerLabel.textColor = .label

        probabilityLabel.font = .systemFont(ofSize: 13)
        probabilityLabel.textColor = .secondaryLabel

        activePatternsLabel.font = .systemFont(ofSize: 13)
        activePatternsLabel.textColor = .secondaryLabel

        avgPriceChangeLabel.font = .systemFont(ofSize: 13)
        avgPriceChangeLabel.textColor = .secondaryLabel

        let topRow = UIStackView(arrangedSubviews: [bestTickerLabel, probabilityLabel])
        topRow.axis = .horizontal
        topRow.spacing = 12

        let bottomRow = UIStackView(arrangedSubviews: [activePatternsLabel, avgPriceChangeLabel])
        bottomRow.axis = .horizontal
        bottomRow.spacing = 12

        let stack = UIStackView(arrangedSubviews: [topRow, bottomRow])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
}
