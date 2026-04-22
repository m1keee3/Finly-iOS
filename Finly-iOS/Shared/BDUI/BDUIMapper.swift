import UIKit

final class BDUIMapper: BDUIMapperProtocol {

    func map(_ node: BDUINode) -> UIView {
        let builtSubviews = node.subviews.map { map($0) }
        let view = buildComponent(node.component, subviews: builtSubviews)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    private func buildComponent(_ component: BDUIComponent, subviews: [UIView]) -> UIView {
        switch component {
        case .label(let config):       return LabelBuilder().build(config: config, subviews: subviews)
        case .button(let config):      return ButtonBuilder().build(config: config, subviews: subviews)
        case .textField(let config):   return TextFieldBuilder().build(config: config, subviews: subviews)
        case .stack(let config):       return StackBuilder().build(config: config, subviews: subviews)
        case .contentView(let config): return ContentViewBuilder().build(config: config, subviews: subviews)
        case .emptyView(let config):   return EmptyViewBuilder().build(config: config, subviews: subviews)
        case .errorView(let config):   return ErrorViewBuilder().build(config: config, subviews: subviews)
        case .loadingView(let config): return LoadingViewBuilder().build(config: config, subviews: subviews)
        case .spacer(let config):      return SpacerBuilder().build(config: config, subviews: subviews)
        case .avatar(let config):      return AvatarBuilder().build(config: config, subviews: subviews)
        }
    }
}

private struct LabelBuilder: ComponentBuilder {
    func build(config: BDUILabelConfig, subviews: [UIView]) -> UIView {
        DSLabel(config: DSLabel.Config(
            text: config.text,
            style: config.style.value,
            numberOfLines: config.numberOfLines ?? 0,
            textAlignment: textAlignment(from: config.textAlignment ?? "natural")
        ))
    }

    private func textAlignment(from string: String) -> NSTextAlignment {
        switch string {
        case "left":    return .left
        case "center":  return .center
        case "right":   return .right
        default:        return .natural
        }
    }
}

private struct ButtonBuilder: ComponentBuilder {
    func build(config: BDUIButtonConfig, subviews: [UIView]) -> UIView {
        let button = DSButton()
        button.configure(DSButton.Config(
            style: config.style.value,
            title: config.title,
            isEnabled: config.isEnabled ?? true
        ))
        if let action = config.action {
            button.addAction(UIAction { _ in
                switch action {
                case .print(let message):
                    Swift.print("[BDUI] \(message)")
                }
            }, for: .touchUpInside)
        }
        return button
    }
}

private struct TextFieldBuilder: ComponentBuilder {
    func build(config: BDUITextFieldConfig, subviews: [UIView]) -> UIView {
        let field = DSTextField()
        let highlight: DSTextField.Highlight = {
            switch config.highlight ?? "normal" {
            case "focused": return .focused
            case "error":   return .error
            default:        return .normal
            }
        }()
        field.configure(DSTextField.Config(
            title: config.title,
            placeholder: config.placeholder,
            isSecure: config.isSecure ?? false,
            highlight: highlight,
            errorMessage: config.errorMessage
        ))
        return field
    }
}

private struct StackBuilder: ComponentBuilder {
    func build(config: BDUIStackConfig, subviews: [UIView]) -> UIView {
        let stack = UIStackView(arrangedSubviews: subviews)
        stack.axis = config.axis?.value ?? .vertical
        stack.spacing = config.spacing?.value ?? DS.Spacing.m
        stack.alignment = config.alignment?.value ?? .fill
        stack.distribution = config.distribution?.value ?? .fill
        return stack
    }
}

private struct ContentViewBuilder: ComponentBuilder {
    func build(config: BDUIContentViewConfig, subviews: [UIView]) -> UIView {
        DSCardView(config: DSCardView.Config(
            backgroundColor: config.backgroundColor?.value ?? DS.Colors.background,
            padding: config.padding?.value ?? 0,
            cornerRadius: config.cornerRadius?.value ?? 0
        ), subviews: subviews)
    }
}

private struct EmptyViewBuilder: ComponentBuilder {
    func build(config: BDUIEmptyViewConfig, subviews: [UIView]) -> UIView {
        let view = DSEmptyView()
        view.configure(DSEmptyView.Config(message: config.message))
        return view
    }
}

private struct ErrorViewBuilder: ComponentBuilder {
    func build(config: BDUIErrorViewConfig, subviews: [UIView]) -> UIView {
        let view = DSErrorView()
        view.configure(DSErrorView.Config(message: config.message))
        return view
    }
}

private struct LoadingViewBuilder: ComponentBuilder {
    func build(config: BDUILoadingViewConfig, subviews: [UIView]) -> UIView {
        let view = DSLoadingView()
        view.configure(DSLoadingView.Config(isAnimating: config.isAnimating ?? true))
        return view
    }
}

private struct AvatarBuilder: ComponentBuilder {
    func build(config: BDUIAvatarConfig, subviews: [UIView]) -> UIView {
        let view = DSAvatarView(config: DSAvatarView.Config(
            size: CGFloat(config.size ?? 80),
            placeholder: config.placeholder
        ))
        view.loadImage(from: config.url)
        return view
    }
}

private struct SpacerBuilder: ComponentBuilder {
    func build(config: BDUISpacerConfig, subviews: [UIView]) -> UIView {
        DSSpacerView(height: config.height?.value)
    }
}
