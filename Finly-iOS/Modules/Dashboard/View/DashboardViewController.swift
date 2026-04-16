import UIKit

final class DashboardViewController: UIViewController {

    private let viewModel: DashboardViewModelProtocol

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let listManager = PatternsListManager()
    private let statsHeaderView = DashboardStatsHeaderView()

    private let loadingView = DSLoadingView()
    private let emptyView = DSEmptyView()
    private let errorView = DSErrorView()

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
        view.backgroundColor = DS.Colors.background
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
        [tableView, loadingView, emptyView, errorView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DS.Spacing.xxl),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DS.Spacing.xxl),

            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DS.Spacing.xxl),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DS.Spacing.xxl),
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
        errorView.onRetry = { [weak self] in self?.viewModel.didTapRetry() }
    }

    @objc private func handleRefresh() {
        viewModel.didPullToRefresh()
    }
}

extension DashboardViewController: DashboardView {

    func render(_ state: DashboardViewState) {
        loadingView.stopAnimating()
        tableView.isHidden = true
        emptyView.isHidden = true
        errorView.isHidden = true

        switch state.loadingState {
        case .idle:
            break

        case .loading:
            loadingView.startAnimating()

        case .refreshing:
            break

        case .content:
            refreshControl.endRefreshing()
            tableView.isHidden = false
            statsHeaderView.configure(with: state.stats)
            listManager.setItems(state.cellViewModels)

        case .empty:
            refreshControl.endRefreshing()
            emptyView.isHidden = false

        case .error(let message):
            refreshControl.endRefreshing()
            errorView.configure(message: message)
            errorView.isHidden = false
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
