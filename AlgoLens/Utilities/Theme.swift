//
//  Theme.swift
//  AlgoLens
//
//  Created by harsh chauhan on 05/01/26.
//

import SwiftUI

struct Theme {
    // MARK: - Colors
    struct Colors {
        static let primaryGradientStart = Color(red: 0.4, green: 0.5, blue: 0.9)
        static let primaryGradientEnd = Color(red: 0.6, green: 0.3, blue: 0.8)
        static let backgroundGradientStart = Color(red: 0.95, green: 0.97, blue: 1.0)
        static let backgroundGradientEnd = Color(red: 0.98, green: 0.95, blue: 1.0)
        static let primaryText = Color.primary
        static let secondaryText = Color.secondary
        static let accent = Color.blue
    }
    
    // MARK: - Fonts
    struct Fonts {
        static let largeTitle = Font.system(size: 40, weight: .bold, design: .rounded)
        static let title = Font.system(size: 24, weight: .semibold, design: .rounded)
        static let subtitle = Font.system(size: 18, weight: .regular, design: .rounded)
        static let body = Font.system(size: 16, weight: .regular, design: .default)
        static let button = Font.system(size: 18, weight: .semibold, design: .rounded)
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let extraLarge: CGFloat = 32
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 24
    }
}
