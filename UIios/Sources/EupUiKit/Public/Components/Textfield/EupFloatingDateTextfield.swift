//
//  EupFloatingDateTextfield.swift
//  EupUiKit
//
//  Created by Артём  on 14.04.2025.
//

import SwiftUI

public struct EupFloatingDateTextfield: View {
    
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
    private var returnApplyedDate: (Date) -> Void
    
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
        onSubmitTap: @escaping (() -> Void) = {},
        returnApplyedDate: @escaping ((Date) -> Void) = { _ in }
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
        self.returnApplyedDate = returnApplyedDate
        self._textFieldText = State(initialValue: text.wrappedValue)
    }
    
    public var body: some View {
        EupFloatingTextfield(
            text: $textFieldText,
            placeholder: placeholder,
            errorString: errorString,
            isFieldDisable: isFieldDisable,
            textContentType: .dateTime,
            keyboardType: .numberPad,
            onClearButtonTap: onClearButtonTap
        )
        .onChange(of: text) { newValue in
            let formatted = format(
                with: "XX.XX.XXXX",
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
            if filtered.count == 8 {
                tryToParseIntoDate(text: textFieldText)
            }
        }
    }
    
    // MARK: - Private Methods
    private func format(
        with mask: String,
        phone: String
    ) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
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
    
    private func tryToParseIntoDate(text: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.timeZone = .current
        guard let date = formatter.date(from: text) else { return }
        print("AHHAHAHAHAAHAH \(date)")
        returnApplyedDate(date)
    }
}

#Preview {
    struct DateTextFieldWrapper: View {
        
        @State private var dateText: String = ""
        
        var body: some View {
            EupFloatingDateTextfield(
                text: $dateText,
                placeholder: "дд.мм.гггг"
            )
        }
    }
    return DateTextFieldWrapper()
}
