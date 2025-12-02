//
//  EupTextCheckbox.swift
//  EupUiKit
//
//  Created by Артём  on 20.02.2025.
//

import SwiftUI

public enum TypeOfTextTitleFontCheckbox {
    case regular
    case semibold
}

struct EupTextCheckbox: View {
    
    @Environment(\.theme) private var theme
    
    private var isSelected: Bool
    private var text: String
    private var subTitle: String = ""
    private var isMultiselect: Bool = false
    private var isError: Bool = false
    private var titleFont: TypeOfTextTitleFontCheckbox = .regular
    private var isDisable: Bool = false
    private var onChecked: (Bool) -> Void
    
    public init(
        isSelected: Bool,
        text: String,
        subTitle: String = "",
        isMultiselect: Bool = false,
        isError: Bool = false,
        titleFont: TypeOfTextTitleFontCheckbox = .regular,
        isDisable: Bool = false,
        onChecked: @escaping (Bool) -> Void = { _ in }
    ) {
        self.isSelected = isSelected
        self.text = text
        self.isMultiselect = isMultiselect
        self.isError = isError
        self.subTitle = subTitle
        self.titleFont = titleFont
        self.isDisable = isDisable
        self.onChecked = onChecked
    }
    
    public var body: some View {
        Button {
            onChecked(!isSelected)
        } label: {
            buttonContent
        }
    }
    
    private var buttonContent: some View {
        VStack(
            alignment: .leading,
            spacing: 4
        ) {
            HStack(alignment: .center) {
                EupText(
                    fontType: titleFont == .regular ? .regular(16) : .semibold(16),
                    text: text,
                    foregroundColor: isError ? theme.informationRed : theme.onBackgroundDarkGray
                )
                .multilineTextAlignment(.leading)
                
                Spacer()
                Checkbox(
                    isSelected: isSelected,
                    isMultiselect: isMultiselect,
                    isError: isError,
                    isDisable: isDisable,
                    onChecked: { onChecked($0) }
                )
            }
            
            if !subTitle.isEmpty {
                EupText(
                    fontType: .regular(14),
                    text: subTitle
                )
            }
        }
    }
}

struct EupTextCheckboxTest: View {
    @State var iss: Bool = false
    
    var body: some View {
        EupTextCheckbox(
            isSelected: iss,
            text: "Тестовый текст",
            isDisable: false,
            onChecked: { iss.toggle(); print($0) }
        )
    }
}

#Preview {
    EupTextCheckboxTest()
}
