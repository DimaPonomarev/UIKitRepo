//
//  EupFloatingPhoneTextfield.swift
//  EupUiKit
//
//  Created by Артём  on 24.03.2025.
//

import SwiftUI

public struct EupFloatingPhoneTextfield: View {
    
    @Binding private var text: String
    private var textContentType: UITextContentType?
    private var keyboardType: UIKeyboardType
    private var submitLabel: SubmitLabel
    private var placeholder: String
    private var errorString: String?
    private var typeOfField: TypeOfTextfield = .simple
    private var isFieldDisable: Bool
    private var onFieldTap: (() -> Void)
    private var onChange: ((String) -> Void)
    private var onClearButtonTap: (() -> Void)
    private var onSubmitTap: (() -> Void)
    
    @State private var textFieldText = ""
    
    public init(
        text: Binding<String>,
        placeholder: String,
        errorString: String? = nil,
        typeOfField: TypeOfTextfield = .simple,
        isFieldDisable: Bool = false,
        textContentType: UITextContentType? = nil,
        keyboardType: UIKeyboardType = .default,
        submitLabel: SubmitLabel = .done,
        onFieldTap: @escaping (() -> Void) = {},
        onChange: @escaping ((String) -> Void) = { _ in },
        onClearButtonTap: @escaping (() -> Void) = {},
        onSubmitTap: @escaping (() -> Void) = {}
    ) {
        self._text = text
        self.textContentType = textContentType
        self.keyboardType = keyboardType
        self.submitLabel = submitLabel
        self.placeholder = placeholder
        self.isFieldDisable = isFieldDisable
        self.onFieldTap = onFieldTap
        self.onChange = onChange
        self.onClearButtonTap = onClearButtonTap
        self.onSubmitTap = onSubmitTap
        self.typeOfField = typeOfField
        self.errorString = errorString
        self._textFieldText = State(initialValue: text.wrappedValue)
    }
    
    public var body: some View {
        EupFloatingTextfield(
            text: $textFieldText,
            placeholder: placeholder,
            errorString: errorString,
            textContentType: .telephoneNumber,
            keyboardType: .phonePad
        )
        .onChange(of: text) { newValue in
            let formatted = format(
                with: "+X (XXX) XXX-XX XX",
                phone: newValue
            )
            if textFieldText != formatted {
                textFieldText = formatted
            }
        }
        .onChange(of: textFieldText) { newValue in
            let filtered = newValue
                .filter { "0123456789".contains($0) }
                .replacingOccurrences(
                    of: "[^0-9]",
                    with: "",
                    options: .regularExpression
                )
            if text != filtered {
                text = filtered
            }
        }
    }
    
    // MARK: - Private Methods
    private func format(
        with mask: String,
        phone: String
    ) -> String {
        let numbers = phone.replacingOccurrences(
            of: "[^0-9]",
            with: "",
            options: .regularExpression
        )
        var result = ""
        var index = numbers.startIndex
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}
