import UIKit

final class DSAvatarView: UIView {

    struct Config {
        let size: CGFloat
        let placeholder: String?

        init(size: CGFloat = 80, placeholder: String? = nil) {
            self.size = size
            self.placeholder = placeholder
        }
    }

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let placeholderLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private var loadTask: Task<Void, Never>?

    init(config: Config) {
        super.init(frame: .zero)

        backgroundColor = DS.Colors.backgroundSecondary
        layer.cornerRadius = config.size / 2
        clipsToBounds = true

        placeholderLabel.text = config.placeholder ?? "👤"
        placeholderLabel.font = .systemFont(ofSize: config.size * 0.4, weight: .medium)

        addSubview(placeholderLabel)
        addSubview(imageView)

        NSLayoutConstraint.activate([
            placeholderLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            widthAnchor.constraint(equalToConstant: config.size),
            heightAnchor.constraint(equalToConstant: config.size),
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        loadTask = Task { @MainActor [weak self] in
            guard let self else { return }
            guard let (data, _) = try? await URLSession.shared.data(from: url),
                  let image = UIImage(data: data),
                  !Task.isCancelled else { return }
            self.imageView.image = image
            self.placeholderLabel.isHidden = true
        }
    }

    deinit {
        loadTask?.cancel()
    }
}
