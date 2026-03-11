import UIKit

final class HomeStubViewController: UIViewController {

    private let session: UserSession

    init(session: UserSession) {
        self.session = session
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
    }

    private func setupLayout() {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis      = .vertical
        stack.alignment = .center
        stack.spacing   = 12
        view.addSubview(stack)

        let title = UILabel()
        title.text = "Вход выполнен!"
        title.font = .systemFont(ofSize: 30, weight: .bold)

        let stub = UILabel()
        stub.text      = "Здесь будет Home экран"
        stub.font      = .systemFont(ofSize: 13)
        stub.textColor = .tertiaryLabel

        [title, stub].forEach { stack.addArrangedSubview($0) }

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
        ])
    }
}
