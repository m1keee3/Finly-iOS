import Foundation

struct BDUINode: Decodable {

    let component: BDUIComponent
    let subviews: [BDUINode]

    private enum CodingKeys: String, CodingKey {
        case type, content, subviews
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let type = try container.decode(String.self, forKey: .type)
        subviews = try container.decodeIfPresent([BDUINode].self, forKey: .subviews) ?? []

        switch type {
        case "label":
            component = .label(try container.decode(BDUILabelConfig.self, forKey: .content))
        case "button":
            component = .button(try container.decode(BDUIButtonConfig.self, forKey: .content))
        case "textField":
            component = .textField(try container.decode(BDUITextFieldConfig.self, forKey: .content))
        case "stack":
            component = .stack(try container.decode(BDUIStackConfig.self, forKey: .content))
        case "contentView":
            component = .contentView(try container.decode(BDUIContentViewConfig.self, forKey: .content))
        case "emptyView":
            component = .emptyView(try container.decode(BDUIEmptyViewConfig.self, forKey: .content))
        case "errorView":
            component = .errorView(try container.decode(BDUIErrorViewConfig.self, forKey: .content))
        case "loadingView":
            component = .loadingView(
                (try? container.decode(BDUILoadingViewConfig.self, forKey: .content)) ?? BDUILoadingViewConfig()
            )
        case "spacer":
            component = .spacer(
                (try? container.decode(BDUISpacerConfig.self, forKey: .content)) ?? BDUISpacerConfig()
            )
        case "avatar":
            component = .avatar(try container.decode(BDUIAvatarConfig.self, forKey: .content))
        default:
            throw DecodingError.dataCorruptedError(
                forKey: .type, in: container,
                debugDescription: "Unknown BDUINode type: \(type)"
            )
        }
    }
}
