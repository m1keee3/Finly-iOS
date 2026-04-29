import UIKit

enum BDUISpacingToken: String, Decodable {
    case xxs, xs, s, m, l, xl, xxl, xxxl, fieldHeight

    var value: CGFloat {
        switch self {
        case .xxs:         return DS.Spacing.xxs
        case .xs:          return DS.Spacing.xs
        case .s:           return DS.Spacing.s
        case .m:           return DS.Spacing.m
        case .l:           return DS.Spacing.l
        case .xl:          return DS.Spacing.xl
        case .xxl:         return DS.Spacing.xxl
        case .xxxl:        return DS.Spacing.xxxl
        case .fieldHeight: return DS.Spacing.fieldHeight
        }
    }
}

enum BDUIColorToken: String, Decodable {
    case accent, destructive, positive
    case background, backgroundSecondary
    case labelPrimary, labelSecondary, labelTertiary
    case separator

    var value: UIColor {
        switch self {
        case .accent:              return DS.Colors.accent
        case .destructive:         return DS.Colors.destructive
        case .positive:            return DS.Colors.positive
        case .background:          return DS.Colors.background
        case .backgroundSecondary: return DS.Colors.backgroundSecondary
        case .labelPrimary:        return DS.Colors.labelPrimary
        case .labelSecondary:      return DS.Colors.labelSecondary
        case .labelTertiary:       return DS.Colors.labelTertiary
        case .separator:           return DS.Colors.separator
        }
    }
}

enum BDUITextStyleToken: String, Decodable {
    case largeTitle, title, body, bodySecondary
    case listTitle, listSubtitle, listMetric
    case sectionHeader, sectionMeta
    case caption, stateLabel, errorBody

    var value: TextStyle {
        switch self {
        case .largeTitle:    return .largeTitle
        case .title:         return .title
        case .body:          return .body
        case .bodySecondary: return .bodySecondary
        case .listTitle:     return .listTitle
        case .listSubtitle:  return .listSubtitle
        case .listMetric:    return .listMetric
        case .sectionHeader: return .sectionHeader
        case .sectionMeta:   return .sectionMeta
        case .caption:       return .caption
        case .stateLabel:    return .stateLabel
        case .errorBody:     return .errorBody
        }
    }
}

enum BDUIButtonStyleToken: String, Decodable {
    case primary, secondary, plain

    var value: DSButton.Style {
        switch self {
        case .primary:   return .primary
        case .secondary: return .secondary
        case .plain:     return .plain
        }
    }
}

enum BDUIStackAxisToken: String, Decodable {
    case vertical, horizontal

    var value: NSLayoutConstraint.Axis {
        switch self {
        case .vertical:   return .vertical
        case .horizontal: return .horizontal
        }
    }
}

enum BDUIStackAlignmentToken: String, Decodable {
    case fill, leading, center, trailing

    var value: UIStackView.Alignment {
        switch self {
        case .fill:     return .fill
        case .leading:  return .leading
        case .center:   return .center
        case .trailing: return .trailing
        }
    }
}

enum BDUIStackDistributionToken: String, Decodable {
    case fill, fillEqually, fillProportionally, equalSpacing, equalCentering

    var value: UIStackView.Distribution {
        switch self {
        case .fill:                return .fill
        case .fillEqually:         return .fillEqually
        case .fillProportionally:  return .fillProportionally
        case .equalSpacing:        return .equalSpacing
        case .equalCentering:      return .equalCentering
        }
    }
}

enum BDUICornerRadiusToken: String, Decodable {
    case field, button

    var value: CGFloat {
        switch self {
        case .field:  return DS.CornerRadius.field
        case .button: return DS.CornerRadius.button
        }
    }
}
