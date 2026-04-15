import UIKit

final class PatternDetailViewController: UIViewController {

    private let patternId: String

    private let idLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    init(patternId: String) {
        self.patternId = patternId
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Детали паттерна"

        idLabel.text = "ID: \(patternId)"
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(idLabel)

        NSLayoutConstraint.activate([
            idLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            idLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            idLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            idLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
        ])
    }
}
