import UIKit

enum TextStyle {
    case largeTitle      // 32pt bold, labelPrimary
    case title           // 17pt regular, labelPrimary
    case body            // 16pt regular, labelPrimary
    case bodySecondary   // 15pt regular, labelSecondary
    case listTitle       // 16pt semibold, labelPrimary
    case listSubtitle    // 13pt regular, labelSecondary
    case listMetric      // 15pt medium, labelSecondary
    case sectionHeader   // 15pt semibold, labelPrimary
    case sectionMeta     // 13pt regular, labelSecondary
    case caption         // 12pt regular, destructive
    case stateLabel      // 17pt regular, labelSecondary
    case errorBody       // 15pt regular, labelSecondary

    var font: UIFont {
        switch self {
        case .largeTitle:    return DS.Typography.largeTitle()
        case .title:         return DS.Typography.title()
        case .body:          return DS.Typography.bodyLarge()
        case .bodySecondary: return DS.Typography.body()
        case .listTitle:     return DS.Typography.bodyLargeSemibold()
        case .listSubtitle:  return DS.Typography.bodySmall()
        case .listMetric:    return DS.Typography.bodyMedium()
        case .sectionHeader: return DS.Typography.bodySmallSemibold()
        case .sectionMeta:   return DS.Typography.bodySmall()
        case .caption:       return DS.Typography.caption()
        case .stateLabel:    return DS.Typography.title()
        case .errorBody:     return DS.Typography.body()
        }
    }

    var color: UIColor {
        switch self {
        case .largeTitle:    return DS.Colors.labelPrimary
        case .title:         return DS.Colors.labelPrimary
        case .body:          return DS.Colors.labelPrimary
        case .bodySecondary: return DS.Colors.labelSecondary
        case .listTitle:     return DS.Colors.labelPrimary
        case .listSubtitle:  return DS.Colors.labelSecondary
        case .listMetric:    return DS.Colors.labelSecondary
        case .sectionHeader: return DS.Colors.labelPrimary
        case .sectionMeta:   return DS.Colors.labelSecondary
        case .caption:       return DS.Colors.destructive
        case .stateLabel:    return DS.Colors.labelSecondary
        case .errorBody:     return DS.Colors.labelSecondary
        }
    }
}

extension UILabel {
    func apply(_ style: TextStyle) {
        font = style.font
        textColor = style.color
    }
}
