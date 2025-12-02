//
//  EupFloatingTextfield.swift
//  EupUiKit
//
//  Created by Артём  on 25.02.2025.
//

import SwiftUI

enum FocusedField: Hashable {
    case tappedOnField
}

public enum TypeOfTextfield {
    case simple
    case secure
    case tapOnly
}

public struct EupFloatingTextfield: View {
    
    @Environment(\.theme) private var theme
    @FocusState private var focusOnFieldWhenTapped: FocusedField?
    
    private var text: Binding<String>
    private var textContentType: UITextContentType?
    private var keyboardType: UIKeyboardType
    private var submitLabel: SubmitLabel
    private var placeholder: String
    private var errorString: String?
    private var typeOfField: TypeOfTextfield = .simple
    private var axis: Axis
    private var maxHeight: CGFloat?
    private var isFieldDisable: Bool
    private var onFieldTap: (() -> Void)
    private var onChange: ((String) -> Void)
    private var onClearButtonTap: (() -> Void)
    private var onSubmitTap: (() -> Void)
    
    public init(
        text: Binding<String>,
        placeholder: String,
        errorString: String? = nil,
        typeOfField: TypeOfTextfield = .simple,
        isFieldDisable: Bool = false,
        textContentType: UITextContentType? = nil,
        keyboardType: UIKeyboardType = .default,
        axis: Axis = .horizontal,
        maxHeight: CGFloat? = nil,
        submitLabel: SubmitLabel = .done,
        onFieldTap: @escaping (() -> Void) = {},
        onChange: @escaping ((String) -> Void) = { _ in },
        onClearButtonTap: @escaping (() -> Void) = {},
        onSubmitTap: @escaping (() -> Void) = {}
    ) {
        self.text = text
        self.textContentType = textContentType
        self.keyboardType = keyboardType
        self.submitLabel = submitLabel
        self.placeholder = placeholder
        self.axis = axis
        self.maxHeight = maxHeight
        self.isFieldDisable = isFieldDisable
        self.onFieldTap = onFieldTap
        self.onChange = onChange
        self.onClearButtonTap = onClearButtonTap
        self.onSubmitTap = onSubmitTap
        self.typeOfField = typeOfField
        self.errorString = errorString
    }
    
    private var textFieldComponent: some View {
        getTextfield()
            .textContentType(textContentType)
            .keyboardType(keyboardType)
            .submitLabel(submitLabel)
            .onChange(
                of: text.wrappedValue,
                perform: onChange
            )
            .setStyleForFloatingTextField(
                withTrigger: _focusOnFieldWhenTapped,
                isError: errorString != nil
            )
            .disabled(isFieldDisable)
            .padding(.trailing, 30)
    }
    
    private var textfieldWithBorder: some View {
        @State var trigger = focusOnFieldWhenTapped == .tappedOnField
        
        return VStack(
            alignment: .leading,
            spacing: 2
        ) {
            Text(placeholder)
                .padding(.horizontal, 12)
                .font(
                    theme.fonts.regular(size: 14)
                )
                .foregroundColor(errorString != nil ? theme.informationRed : theme.onSurfaceDarkGray)
                .offset(y: trigger || !text.wrappedValue.isEmpty ? 0 : 8.5)
            textFieldComponent
        }
        .padding(.vertical, 10)
        .setFloatingPlaceholderWithBorder(
            trigger: trigger,
            isError: errorString != nil
        )
    }
    
    private var traillingButton: some View {
        Button {
            traillingTextfieldButtonAction()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.secondary)
                .drawingGroup()
                .padding(.horizontal, 14)
                .padding(.vertical, 14)
        }
    }
    
    public var body: some View {
        VStack(
            alignment: .leading,
            spacing: 5
        ) {
            textfieldWithBorder
                .background(!isFieldDisable ? theme.onSurfaceWhite : theme.surfaceLightGray)
                .onSubmit {
                    onSubmitTap()
                }
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .overlay(alignment: .trailing) {
                    if !text.wrappedValue.isEmpty && !isFieldDisable {
                        traillingButton
                    }
                }
                .opacity(isFieldDisable ? 0.6 : 1)
                .animation(.smooth(duration: 0.12), value: text.wrappedValue.isEmpty && !isFieldDisable)
            
            if let error = errorString {
                EupText(
                    fontType: .regular(12),
                    text: error,
                    foregroundColor: theme.informationRed
                )
                .padding(.leading, 12)
            }
        }
        .animation(
            .smooth(duration: 0.15),
            value: errorString
        )
        .onTapGesture {
            if (!isFieldDisable) {
                focusOnFieldWhenTapped = .tappedOnField
                onFieldTap()
            }
        }
        .frame(maxHeight: maxHeight)
    }
    
    private func traillingTextfieldButtonAction() {
        text.wrappedValue = ""
        onClearButtonTap()
    }
    
    @ViewBuilder
    private func getTextfield() -> some View {
        switch typeOfField {
        case .simple:
            if #available(iOS 16.0, *) {
                TextField(
                    "",
                    text: text,
                    axis: axis
                )
            } else {
                TextField(
                    "",
                    text: text
                )
            }
        case .secure:
            SecureField("", text: text)
        case .tapOnly:
            HStack {
                Text(text.wrappedValue)
                Spacer()
            }
        }
    }
}


#Preview {
    struct TextfieldPreview: View {
        
        @State private var text: String = "232323123123123123131232323123123123123131232323123123123123131232323123123123123131"
        
        var body: some View {
            EupFloatingTextfield(
                text: $text,
                placeholder: "Текст",
                typeOfField: .simple
            )
        }
    }
    
    return TextfieldPreview()
}
