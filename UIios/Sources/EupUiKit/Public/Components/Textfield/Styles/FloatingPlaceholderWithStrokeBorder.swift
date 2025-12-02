//
//  FloatingPlaceholderWithStrokeBorder.swift
//  EupUiKit
//
//  Created by Артём  on 25.02.2025.
//

import SwiftUI

extension View {
    func setFloatingPlaceholderWithBorder(
        trigger: Bool,
        isError: Bool = false
    ) -> some View {
        modifier(
            FloatingPlaceholderWithStrokeBorder(
                focusOnFiledWhenTapped: trigger,
                isError: isError
            )
        )
    }
}

struct FloatingPlaceholderWithStrokeBorder: ViewModifier {
    
    @Environment(\.theme) private var theme
    var focusOnFiledWhenTapped: Bool
    var isError: Bool
    
    private var borderOverlayedView: some View {
        RoundedRectangle(cornerRadius: 12)
            .inset(by: 0.5)
            .stroke(
                focusOnFiledWhenTapped ?
                isError ? theme.informationRed : theme.primaryColor
                : isError ? theme.informationRed : theme.onSurfaceLightGray,
                lineWidth: 1
            )
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(
                borderOverlayedView
                    .drawingGroup()
            )
    }
}
