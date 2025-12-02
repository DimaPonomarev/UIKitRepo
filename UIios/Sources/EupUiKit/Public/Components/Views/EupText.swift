//
//  Untitled.swift
//  EupUiKit
//
//  Created by Артём  on 20.02.2025.
//

import SwiftUI

public enum FontType {
    case regular(CGFloat)
    case medium(CGFloat)
    case semibold(CGFloat)
}

public struct EupText: View {
    
    @Environment(\.theme) private var theme
    
    private var fontType: FontType
    private var text: String
    private var foregroundColor: Color?
    
    public init(
        fontType: FontType,
        text: String,
        foregroundColor: Color? = nil
    ) {
        self.fontType = fontType
        self.text = text
        self.foregroundColor = foregroundColor
    }
    
    public var body: some View {
        Text(text)
            .font(getFont())
            .foregroundStyle(getColorOfText())
    }
    
    private func getFont() -> Font {
        switch fontType {
        case .regular(let size):
            return theme.fonts.regular(size: size)
        case .medium(let size):
            return theme.fonts.medium(size: size)
        case .semibold(let size):
            return theme.fonts.semiBold(size: size)
        }
    }
    
    private func getColorOfText() -> Color {
        if let notDefaultColor = foregroundColor {
            return notDefaultColor
        }
        
        return theme.onSurfaceDarkGray
    }
}

#Preview {
    EupText(
        fontType: .semibold(16),
        text: "Тестовый текст"
    )
}


