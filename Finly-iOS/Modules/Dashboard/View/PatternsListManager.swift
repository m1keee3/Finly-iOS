import UIKit

protocol PatternsListManagerDelegate: AnyObject {
    func didSelect(id: String)
}

final class PatternsListManager: NSObject {

    weak var delegate: PatternsListManagerDelegate?

    private weak var tableView: UITableView?
    private var diffableDataSource: UITableViewDiffableDataSource<Int, String>!
    private var itemsById: [String: PatternCellViewModel] = [:]

    func setup(tableView: UITableView) {
        self.tableView = tableView
        tableView.register(PatternTableViewCell.self, forCellReuseIdentifier: PatternTableViewCell.reuseIdentifier)
        tableView.delegate = self

        diffableDataSource = UITableViewDiffableDataSource<Int, String>(
            tableView: tableView
        ) { [weak self] tableView, indexPath, itemId in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: PatternTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! PatternTableViewCell
            if let viewModel = self?.itemsById[itemId] {
                cell.configure(with: viewModel)
            }
            return cell
        }
        tableView.dataSource = diffableDataSource
    }

    func setItems(_ items: [PatternCellViewModel]) {
        itemsById = Dictionary(uniqueKeysWithValues: items.map { ($0.id, $0) })
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(items.map { $0.id }, toSection: 0)
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension PatternsListManager: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let itemId = diffableDataSource.itemIdentifier(for: indexPath) else { return }
        delegate?.didSelect(id: itemId)
    }
}
