//
//  SnackbarConfiguration.swift
//  EupUiKit
//
//  Created by Артём  on 17.02.2025.
//

import SwiftUI

public enum CustomSnackbarAlignment {
    case trailling
    case bottomTrailling
}

public enum SnackbarType {
    case error
    case success
    case info
}

public enum SnackbarConfiguration {
    case error(Theme)
    case success(Theme)
    case info(Theme)
    
    init(
        theme: Theme,
        snackType: SnackbarType
    ) {
        switch snackType {
        case .error:
            self = .error(theme)
        case .success:
            self = .success(theme)
        case .info:
            self = .info(theme)
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .error(let theme):
            return theme.informationRed
        case .success(let theme):
            return theme.surfaceGreen
        case .info(let theme):
            return theme.onBackgroundDarkGray
        }
    }
    
    var textColor: Color {
        switch self {
        case .error(let theme):
            return theme.onSurfaceWhite
        case .success(let theme):
            return theme.onSurfaceWhite
        case .info(let theme):
            return theme.onSurfaceWhite
        }
    }
    
    var cornerRadius: CGFloat {
        return 6
    }
}
