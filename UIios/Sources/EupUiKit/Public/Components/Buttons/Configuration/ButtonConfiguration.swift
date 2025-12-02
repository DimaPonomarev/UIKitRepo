//
//  ButtonConfiguration.swift
//  EupUiKit
//
//  Created by Артём  on 12.02.2025.
//

import SwiftUI

public enum ButtonType {
    case containedPrimaryColor
    case outlineButton
    case outlineButtonPrimaryColor
    case gray
    case withTextOnly(Color)
}

public enum ButtonConfiguration {
    case containedPrimaryColor(Theme)
    case outlineButton(Theme)
    case outlineButtonPrimaryColor(Theme)
    case gray(Theme)
    case withTextOnly(Color)
    
    init(
        theme: Theme,
        buttonType: ButtonType
    ) {
        switch buttonType {
        case .containedPrimaryColor:
            self = .containedPrimaryColor(theme)
        case .outlineButton:
            self = .outlineButton(theme)
        case .outlineButtonPrimaryColor:
            self = .outlineButtonPrimaryColor(theme)
        case .withTextOnly(let color):
            self = .withTextOnly(color)
        case .gray:
            self = .gray(theme)
        }
    }
    
    // MARK: - Properties
    var backgroundColor: Color {
        switch self {
        case .containedPrimaryColor(let theme):
            return theme.primaryColor
        case .outlineButton(_):
            return Color.clear
        case .outlineButtonPrimaryColor(_):
            return Color.clear
        case .withTextOnly(_):
            return Color.clear
        case .gray(let theme):
            return theme.surfaceLightGray
        }
    }
    
    var titleColor: Color {
        switch self {
        case .containedPrimaryColor(_):
            return .white
        case .outlineButton(let theme):
            return theme.onBackgroundLightGray
        case .outlineButtonPrimaryColor(let theme):
            return theme.primaryColor
        case .withTextOnly(let color):
            return color
        case .gray(let theme):
            return theme.onSurfaceLightGray
        }
    }
    
    var cornerRadius: CGFloat {
        return 6
    }
    
    var borderColor: Color {
        switch self {
        case .containedPrimaryColor(_):
            return Color.clear
        case .outlineButton(let theme):
            return theme.onSurfaceLightGray
        case .outlineButtonPrimaryColor(let theme):
            return theme.primaryColor
        case .withTextOnly(_):
            return Color.clear
        case .gray(_):
            return Color.clear
        }
    }
    
    var showBorder: Bool {
        switch self {
        case .outlineButton(_): return true
        case .outlineButtonPrimaryColor(_): return true
        default: return false
        }
    }
    
    // MARK: - Public func
    func getOpacityOfBackground(_ bool: Bool) -> CGFloat {
        bool ? 0.35 : 1
    }
}
