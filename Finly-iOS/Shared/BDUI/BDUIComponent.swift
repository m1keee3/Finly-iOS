import Foundation

struct BDUILabelConfig: Decodable {
    let text: String
    let style: BDUITextStyleToken
    var numberOfLines: Int?
    var textAlignment: String?
}

struct BDUIButtonConfig: Decodable {
    let title: String
    let style: BDUIButtonStyleToken
    var isEnabled: Bool?
    var action: BDUIAction?
}

struct BDUITextFieldConfig: Decodable {
    let title: String
    let placeholder: String
    var isSecure: Bool?
    var highlight: String?
    var errorMessage: String?
}

struct BDUIStackConfig: Decodable {
    var axis: BDUIStackAxisToken?
    var spacing: BDUISpacingToken?
    var alignment: BDUIStackAlignmentToken?
    var distribution: BDUIStackDistributionToken?
}

struct BDUIContentViewConfig: Decodable {
    var backgroundColor: BDUIColorToken?
    var padding: BDUISpacingToken?
    var cornerRadius: BDUICornerRadiusToken?
}

struct BDUIEmptyViewConfig: Decodable {
    let message: String
}

struct BDUIErrorViewConfig: Decodable {
    let message: String
}

struct BDUILoadingViewConfig: Decodable {
    var isAnimating: Bool?
}

struct BDUISpacerConfig: Decodable {
    var height: BDUISpacingToken?
}

struct BDUIAvatarConfig: Decodable {
    let url: String
    var size: Double?
    var placeholder: String?
}

enum BDUIComponent {
    case label(BDUILabelConfig)
    case button(BDUIButtonConfig)
    case textField(BDUITextFieldConfig)
    case stack(BDUIStackConfig)
    case contentView(BDUIContentViewConfig)
    case emptyView(BDUIEmptyViewConfig)
    case errorView(BDUIErrorViewConfig)
    case loadingView(BDUILoadingViewConfig)
    case spacer(BDUISpacerConfig)
    case avatar(BDUIAvatarConfig)
}
