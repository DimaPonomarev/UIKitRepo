//
//  File.swift
//  EupUiKit
//
//  Created by Артём  on 10.02.2025.
//

import Foundation
import SwiftUI

public struct FontsTheme : Sendable{
    let regularFontName: String
    let mediumFontName: String
    let semiBoldFontName: String
    
    public init(
        regularFontName: String,
        mediumFontName: String,
        semiBoldFontName: String
    ) {
        self.regularFontName = regularFontName
        self.mediumFontName = mediumFontName
        self.semiBoldFontName = semiBoldFontName
    }
    
    func regular(size: CGFloat) -> Font {
        FontsLoader.loadCustomFont(
            name: regularFontName,
            size: size
        )
    }
    
    func medium(size: CGFloat) -> Font {
        FontsLoader.loadCustomFont(
            name: mediumFontName,
            size: size
        )
    }
    
    func semiBold(size: CGFloat) -> Font {
        FontsLoader.loadCustomFont(
            name: semiBoldFontName,
            size: size
        )
    }
}

public struct Theme : Sendable {
    public var primaryColor: Color
    public var primaryVariant: Color
    public var secondaryColor: Color
    public var backgroundColor: Color
    public var surfaceColor: Color
    public var informationRed: Color
    public var onBackgroundDarkGray: Color
    public var onSurfaceDarkGray: Color
    public var onSurfaceLightGray: Color
    public var onSurfacePrimaryColor: Color
    public var onPrimaryWhite: Color
    public var onBackgroundLightGray: Color
    public var onSurfaceSecondaryColor: Color
    public var onSurfaceInformationRed: Color
    public var onSurfaceLightBlue: Color
    public var surfaceLightGray: Color
    public var surfaceYellow: Color
    public var onSurfaceWhite: Color
    public var informationGreen: Color
    public var surfaceGreen: Color
    public var surfaceDark: Color
    public var onSurfaceGreen: Color
    public var fonts: FontsTheme
    
    public init(
        primaryColor: UIColor,
        primaryVariant: UIColor,
        secondaryColor: UIColor,
        backgroundColor: UIColor,
        surfaceColor: UIColor,
        informationRed: UIColor,
        onBackgroundDarkGray: UIColor,
        onSurfaceDarkGray: UIColor,
        onSurfaceLightGray: UIColor,
        onSurfacePrimaryColor: UIColor,
        onPrimaryWhite: UIColor,
        onBackgroundLightGray: UIColor,
        onSurfaceSecondaryColor: UIColor,
        onSurfaceInformationRed: UIColor,
        onSurfaceLightBlue: UIColor,
        surfaceLightGray: UIColor,
        surfaceYellow: UIColor,
        onSurfaceWhite: UIColor,
        informationGreen: UIColor,
        surfaceGreen: UIColor,
        onSurfaceGreen: UIColor,
        surfaceDark: UIColor,
        fonts: FontsTheme
    ) {
        self.primaryColor = Color(uiColor: primaryColor)
        self.primaryVariant = Color(uiColor: primaryVariant)
        self.backgroundColor = Color(uiColor: backgroundColor)
        self.surfaceColor = Color(uiColor: surfaceColor)
        self.informationRed = Color(uiColor: informationRed)
        self.onBackgroundDarkGray = Color(uiColor: onBackgroundDarkGray)
        self.onSurfaceDarkGray = Color(uiColor: onSurfaceDarkGray)
        self.onSurfaceLightGray = Color(uiColor: onSurfaceLightGray)
        self.onSurfacePrimaryColor = Color(uiColor: onSurfacePrimaryColor)
        self.onPrimaryWhite = Color(uiColor: onPrimaryWhite)
        self.onBackgroundLightGray = Color(uiColor: onBackgroundLightGray)
        self.secondaryColor = Color(uiColor: secondaryColor)
        self.onSurfaceSecondaryColor = Color(uiColor: onSurfaceSecondaryColor)
        self.onSurfaceInformationRed = Color(uiColor: onSurfaceInformationRed)
        self.onSurfaceLightBlue = Color(uiColor: onSurfaceLightBlue)
        self.surfaceLightGray = Color(uiColor: surfaceLightGray)
        self.surfaceYellow = Color(uiColor: surfaceYellow)
        self.onSurfaceWhite = Color(uiColor: onSurfaceWhite)
        self.informationGreen = Color(uiColor: informationGreen)
        self.surfaceGreen = Color(uiColor: informationGreen)
        self.onSurfaceGreen = Color(uiColor: onSurfaceGreen)
        self.surfaceDark = Color(uiColor: surfaceDark)
        self.fonts = fonts
    }
}

// MARK: - Default theme color
public extension Theme {
    static let `default` = Theme(
        primaryColor: .primaryColor,
        primaryVariant: .primaryVariant,
        secondaryColor: .secondaryColor,
        backgroundColor: .backgroundColor,
        surfaceColor: .surfaceColor,
        informationRed: .informationRed,
        onBackgroundDarkGray: .onBackgroundDarkGray,
        onSurfaceDarkGray: .onSurfaceDarkGray,
        onSurfaceLightGray: .onSurfaceLightGray,
        onSurfacePrimaryColor: .onSurfacePrimaryColor,
        onPrimaryWhite: .onPrimaryWhite,
        onBackgroundLightGray: .onBackgroundLightGray,
        onSurfaceSecondaryColor: .onSurfaceSecondaryColor,
        onSurfaceInformationRed: .onSurfaceInformationRed,
        onSurfaceLightBlue: .onSurfaceLightBlue,
        surfaceLightGray: .surfaceLightGray,
        surfaceYellow: .surfaceYellow,
        onSurfaceWhite: .onSurfaceWhite,
        informationGreen: .informationGreen,
        surfaceGreen: .surfaceGreen,
        onSurfaceGreen: .onSurfaceGreen,
        surfaceDark: .surfaceDark,
        fonts: FontsTheme(
            regularFontName: "Inter-Regular",
            mediumFontName: "Inter-Medium",
            semiBoldFontName: "Inter-SemiBold"
        )
    )
}

// MARK: - Made key for Environment
private struct ThemeKey: EnvironmentKey {
    static let defaultValue: Theme = .default
}

public extension EnvironmentValues {
    var theme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}
