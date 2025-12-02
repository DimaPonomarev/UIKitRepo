//
//  StyleForFloationTextField.swift
//  EupUiKit
//
//  Created by Артём  on 25.02.2025.
//

import SwiftUI

extension View {
    func setStyleForFloatingTextField(
        withTrigger: FocusState<FocusedField?>,
        isError: Bool = false
    ) -> some View {
        modifier(
            StyleForFloationTextField(
                focusOnFiledWhenTapped: withTrigger,
                isError: isError
            )
        )
    }
}

struct StyleForFloationTextField: ViewModifier {
    
    @Environment(\.theme) private var theme
    @FocusState var focusOnFiledWhenTapped: FocusedField?
    var isError: Bool
    
    func body(content: Content) -> some View {
        content
            .tint(isError ? theme.informationRed : theme.primaryColor)
            .font(theme.fonts.regular(size: 14))
            .padding(.horizontal, 12)
            .focused(
                $focusOnFiledWhenTapped,
                equals: .tappedOnField
            )
            .autocorrectionDisabled()
            .autocapitalization(.none)
            .keyboardType(.alphabet)
            .textContentType(.username)
    }
}
