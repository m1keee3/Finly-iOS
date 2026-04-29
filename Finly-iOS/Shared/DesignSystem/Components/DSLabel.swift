import UIKit

final class DSLabel: UILabel {

    struct Config {
        let text: String
        let style: TextStyle
        var numberOfLines: Int
        var textAlignment: NSTextAlignment

        init(
            text: String,
            style: TextStyle,
            numberOfLines: Int = 0,
            textAlignment: NSTextAlignment = .natural
        ) {
            self.text = text
            self.style = style
            self.numberOfLines = numberOfLines
            self.textAlignment = textAlignment
        }
    }

    init(config: Config) {
        super.init(frame: .zero)
        self.text = config.text
        self.numberOfLines = config.numberOfLines
        self.textAlignment = config.textAlignment
        apply(config.style)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}
