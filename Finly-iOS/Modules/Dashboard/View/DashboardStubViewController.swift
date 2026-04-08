import UIKit

final class DashboardStubViewController: UIViewController {

    private let viewModel: DashboardViewModelProtocol
    private let statusLabel  = UILabel()
    private let statsLabel   = UILabel()
    private let countLabel   = UILabel()
    private let retryButton  = UIButton(type: .system)

    init(viewModel: DashboardViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Dashboard"
        setupLayout()
        viewModel.didLoad()
    }

    private func setupLayout() {
        statusLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        statusLabel.textAlignment = .center

        statsLabel.font = .systemFont(ofSize: 14)
        statsLabel.textColor = .secondaryLabel
        statsLabel.textAlignment = .center

        countLabel.font = .systemFont(ofSize: 13)
        countLabel.textColor = .tertiaryLabel
        countLabel.textAlignment = .center

        retryButton.setTitle("Повторить", for: .normal)
        retryButton.isHidden = true
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [statusLabel, statsLabel, countLabel, retryButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 12
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
        ])
    }

    @objc private func retryTapped() {
        viewModel.didTapRetry()
    }
}

extension DashboardStubViewController: DashboardView {

    func render(_ state: DashboardViewState) {
        retryButton.isHidden = true
        statusLabel.textColor = .label

        switch state.loadingState {
        case .idle:
            statusLabel.text = "Ожидание..."
            statsLabel.text = nil
            countLabel.text = nil

        case .loading:
            statusLabel.text = "Загрузка..."
            statsLabel.text = nil
            countLabel.text = nil

        case .content:
            statusLabel.text = "Данные загружены"
            if let s = state.stats {
                let prob = Int(s.bestProbability * 100)
                statsLabel.text = "Лучший: \(s.bestTicker) · \(prob)% · всего паттернов: \(s.activePatterns)"
                let avgChange = String(format: "%.2f", s.avgPriceChange * 100)
                countLabel.text = "Показано: \(state.filteredPatterns.count) · ср. изм. цены: \(avgChange)%"
            }

        case .empty:
            statusLabel.text = "Нет данных"
            statsLabel.text = nil
            countLabel.text = nil

        case .error(let message):
            statusLabel.text = message
            statusLabel.textColor = .systemRed
            statsLabel.text = nil
            countLabel.text = nil
            retryButton.isHidden = false
        }
    }
}
