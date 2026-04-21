import UIKit

final class DashboardViewController: UIViewController {

    private let viewModel: DashboardViewModelProtocol

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let listManager = PatternsListManager()
    private let statsHeaderView = DashboardStatsHeaderView()

    private let spinner = UIActivityIndicatorView(style: .medium)

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Паттерны не найдены"
        label.font = .systemFont(ofSize: 17)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Повторить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return button
    }()

    private lazy var errorStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [errorLabel, retryButton])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 12
        return stack
    }()

    private let refreshControl = UIRefreshControl()

    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Поиск по тикеру"
        return sc
    }()

    init(viewModel: DashboardViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Dashboard"

        setupNavigationBar()
        setupLayout()
        setupTableView()
        setupActions()

        viewModel.didLoad()
    }

    private func setupNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func setupLayout() {
        [tableView, spinner, emptyLabel, errorStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            errorStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            errorStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
        ])
    }

    private func setupTableView() {
        listManager.setup(tableView: tableView)
        listManager.delegate = self
        tableView.refreshControl = refreshControl

        statsHeaderView.frame = CGRect(x: 0, y: 0, width: 0, height: 64)
        tableView.tableHeaderView = statsHeaderView
    }

    private func setupActions() {
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        retryButton.addTarget(self, action: #selector(handleRetry), for: .touchUpInside)
    }
    
    @objc private func handleRefresh() {
        viewModel.didPullToRefresh()
    }

    @objc private func handleRetry() {
        viewModel.didTapRetry()
    }
}

extension DashboardViewController: DashboardView {

    func render(_ state: DashboardViewState) {
        spinner.isHidden = true
        spinner.stopAnimating()
        tableView.isHidden = true
        emptyLabel.isHidden = true
        errorStack.isHidden = true

        switch state.loadingState {
        case .idle:
            break

        case .loading:
            spinner.isHidden = false
            spinner.startAnimating()

        case .refreshing:
            break

        case .content:
            refreshControl.endRefreshing()
            tableView.isHidden = false
            statsHeaderView.configure(with: state.stats)
            listManager.setItems(state.cellViewModels)

        case .empty:
            refreshControl.endRefreshing()
            emptyLabel.isHidden = false

        case .error(let message):
            refreshControl.endRefreshing()
            errorLabel.text = message
            errorStack.isHidden = false
        }
    }
}

extension DashboardViewController: PatternsListManagerDelegate {

    func didSelect(id: String) {
        viewModel.didSelectPattern(id)
    }
}

extension DashboardViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        viewModel.didChangeSearch(searchController.searchBar.text)
    }
}
