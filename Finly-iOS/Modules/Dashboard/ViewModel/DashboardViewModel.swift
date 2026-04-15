import Foundation

final class DashboardViewModel: DashboardViewModelProtocol {

    weak var view: DashboardView?
    private let service: DashboardServiceProtocol
    private weak var coordinator: DashboardCoordinatorProtocol?

    private var loadTask: Task<Void, Never>?

    private var state = DashboardViewState() {
        didSet {
            guard state != oldValue else { return }
            view?.render(state)
        }
    }

    private var patterns: [PatternListItem] = []
    private var filter: PatternsFilter = PatternsFilter()
    private var searchQuery: String = ""
    private var isPullToRefresh = false

    private var currentPage: Int = 0
    private let pageSize: Int = 20

    init(
        service: DashboardServiceProtocol,
        coordinator: DashboardCoordinatorProtocol
    ) {
        self.service = service
        self.coordinator = coordinator
    }

    func didLoad() {
        load()
    }

    func didPullToRefresh() {
        isPullToRefresh = true
        cancelAndReset()
        load()
    }

    func didTapRetry() {
        cancelAndReset()
        load()
    }

    func didUpdateFilter(_ filter: PatternsFilter) {
        self.filter = filter
        applyFilter()
    }

    func didChangeMinMatches(_ value: Int) {
        filter.minMatches = value
        applyFilter()
    }

    func didChangePatternType(_ type: PatternType) {
        filter.patternType = type
        applyFilter()
    }

    func didChangeSortBy(_ sortBy: PatternsSortBy) {
        filter.sortBy = sortBy
        applyFilter()
    }

    func didToggleSortOrder() {
        filter.sortAscending.toggle()
        applyFilter()
    }

    func didSelectPattern(_ patternId: String) {
        coordinator?.showPatternDetails(for: patternId)
    }

    func didChangeSearch(_ query: String?) {
        searchQuery = query ?? ""
        applyFilter()
    }

    private func applyFilter() {
        let filtered = patterns
            .filter { $0.matchesCount >= filter.minMatches }
            .filter { filter.patternType == .all ? true : $0.patternType == filter.patternType }
            .filter {
                searchQuery.isEmpty
                    ? true
                    : $0.ticker.localizedCaseInsensitiveContains(searchQuery)
                        || $0.companyCode.localizedCaseInsensitiveContains(searchQuery)
            }
            .sorted { lhs, rhs in
                switch filter.sortBy {
                case .probability:
                    return filter.sortAscending ? lhs.probability < rhs.probability : lhs.probability > rhs.probability
                case .matches:
                    return filter.sortAscending ? lhs.matchesCount < rhs.matchesCount : lhs.matchesCount > rhs.matchesCount
                case .priceChange:
                    return filter.sortAscending ? lhs.priceChange < rhs.priceChange : lhs.priceChange > rhs.priceChange
                }
            }

        state.cellViewModels = filtered.map { PatternCellViewModel(from: $0) }

        switch state.loadingState {
        case .content, .empty:
            state.loadingState = filtered.isEmpty ? .empty : .content
        default:
            break
        }
    }

    private func cancelAndReset() {
        loadTask?.cancel()
        loadTask = nil
        service.invalidateCache()
        currentPage = 0
    }

    private func load() {
        loadTask?.cancel()

        state.loadingState = isPullToRefresh ? .refreshing : .loading
        isPullToRefresh = false

        loadTask = Task { @MainActor [weak self] in
            guard let self else { return }

            do {
                async let stats = self.service.fetchStats()
                async let loadedPatterns = self.service.fetchPatterns(
                    filter: self.filter,
                    page: self.currentPage,
                    pageSize: self.pageSize
                )

                let (loadedStats, newPatterns) = try await (stats, loadedPatterns)

                guard !Task.isCancelled else { return }

                self.state.stats = loadedStats
                self.patterns = newPatterns
                self.state.loadingState = newPatterns.isEmpty ? .empty : .content
                self.applyFilter()

            } catch is CancellationError {
                return
            } catch let networkError as NetworkError {
                guard !Task.isCancelled else { return }
                self.state.loadingState = .error(networkError.errorDescription ?? "Неизвестная ошибка")
            } catch {
                guard !Task.isCancelled else { return }
                self.state.loadingState = .error(error.localizedDescription)
            }
        }
    }
}
