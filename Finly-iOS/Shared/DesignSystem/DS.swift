import UIKit

enum DS {

    enum Colors {
        static let accent: UIColor              = .systemBlue
        static let destructive: UIColor         = .systemRed
        static let positive: UIColor            = .systemGreen
        static let background: UIColor          = .systemBackground
        static let backgroundSecondary: UIColor = .secondarySystemBackground
        static let labelPrimary: UIColor        = .label
        static let labelSecondary: UIColor      = .secondaryLabel
        static let labelTertiary: UIColor       = .tertiaryLabel
        static let separator: UIColor           = .separator
    }

    enum Typography {
        static func largeTitle() -> UIFont       { .systemFont(ofSize: 32, weight: .bold) }
        static func title() -> UIFont            { .systemFont(ofSize: 17) }
        static func bodyLarge() -> UIFont        { .systemFont(ofSize: 16) }
        static func bodyLargeSemibold() -> UIFont { .systemFont(ofSize: 16, weight: .semibold) }
        static func body() -> UIFont             { .systemFont(ofSize: 15) }
        static func bodyMedium() -> UIFont       { .systemFont(ofSize: 15, weight: .medium) }
        static func bodySmallSemibold() -> UIFont { .systemFont(ofSize: 15, weight: .semibold) }
        static func bodySmall() -> UIFont        { .systemFont(ofSize: 13) }
        static func caption() -> UIFont          { .systemFont(ofSize: 12) }
    }

    enum Spacing {
        static let xxs: CGFloat     =  3   // inner cell stack spacing
        static let xs: CGFloat      =  4   // stats header row gap
        static let s: CGFloat       =  8   // row horizontal gap
        static let m: CGFloat       = 12   // standard gap, cell top/bottom padding
        static let l: CGFloat       = 16   // horizontal container padding
        static let xl: CGFloat      = 24   // section gap
        static let xxl: CGFloat     = 32   // page bottom padding
        static let xxxl: CGFloat    = 40   // hero element gap
        static let fieldHeight: CGFloat = 52  // input field / button height
    }

    enum CornerRadius {
        static let field: CGFloat  = 12
        static let button: CGFloat = 12
    }
}
