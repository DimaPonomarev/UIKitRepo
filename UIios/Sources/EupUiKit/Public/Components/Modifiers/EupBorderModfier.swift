//
//  EupBorderModifier.swift
//  EupUiKit
//
//  Created by Артем Соловьев on 11.07.2025.
//

import SwiftUI

public extension View {
    @ViewBuilder
    func setEupBorder(
        cornerRadius: CGFloat,
        lineWidth: CGFloat = 1,
        colorStroke: Color
    ) -> some View {
        modifier(
            EupBorderModfier(
                cornerRadius: cornerRadius,
                lineWidth: lineWidth,
                colorStroke: colorStroke
            )
        )
    }
}

struct EupBorderModfier: ViewModifier {
    
    private let cornerRadius: CGFloat
    private let lineWidth: CGFloat
    private let colorStroke: Color
    
    init(
        cornerRadius: CGFloat,
        lineWidth: CGFloat = 1,
        colorStroke: Color
    ) {
        self.cornerRadius = cornerRadius
        self.lineWidth = lineWidth
        self.colorStroke = colorStroke
    }
    
    func body(content: Content) -> some View {
        content
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .inset(by: 0.5)
                    .stroke(
                        colorStroke,
                        lineWidth: lineWidth
                    )
            }
    }
}
