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
        cancelAndReset()
        load()
    }

    func didTapRetry() {
        cancelAndReset()
        load()
    }

    func didUpdateFilter(_ filter: PatternsFilter) {
        state.filter = filter
    }

    func didChangeMinMatches(_ value: Int) {
        state.filter.minMatches = value
    }

    func didChangePatternType(_ type: PatternType) {
        state.filter.patternType = type
    }

    func didChangeSortBy(_ sortBy: PatternsSortBy) {
        state.filter.sortBy = sortBy
    }

    func didToggleSortOrder() {
        state.filter.sortAscending.toggle()
    }

    func didSelectPattern(_ patternId: String) {
        coordinator?.showPatternDetails(for: patternId)
    }

    private func cancelAndReset() {
        loadTask?.cancel()
        loadTask = nil
        service.invalidateCache()
        currentPage = 0
    }

    private func load() {
        loadTask?.cancel()

        state.loadingState = .loading

        loadTask = Task { @MainActor [weak self] in
            guard let self else { return }

            do {
                async let stats = self.service.fetchStats()
                async let patterns = self.service.fetchPatterns(
                    filter: self.state.filter,
                    page: self.currentPage,
                    pageSize: self.pageSize
                )

                let (loadedStats, loadedPatterns) = try await (stats, patterns)

                guard !Task.isCancelled else { return }

                self.state.stats = loadedStats
                self.state.patterns = loadedPatterns
                self.state.loadingState = loadedPatterns.isEmpty ? .empty : .content

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
