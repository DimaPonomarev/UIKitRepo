//
//  SwiftUIView.swift
//  EupUiKit
//
//  Created by Артём  on 10.02.2025.
//

import SwiftUI

public struct EupButton: View {
    @Environment(\.theme) private var theme
    
    private var buttonType: ButtonType
    private var title: String
    private var leadingImage: UIImage?
    private var trailingImage: UIImage?
    private var alignment: Alignment = .center
    private var isDisable: Bool = false
    private var maxWidth: Bool = true
    private var action: () -> Void
    
    private var buttonConfiguration: ButtonConfiguration {
        ButtonConfiguration(
            theme: theme,
            buttonType: buttonType
        )
    }
    
    public init(
        buttonType: ButtonType,
        title: String,
        leadingImage: UIImage? = nil,
        trailingImage: UIImage? = nil,
        alignment: Alignment = .center,
        isDisable: Bool = false,
        maxWidth: Bool = true,
        action: @escaping () -> Void
    ) {
        self.buttonType = buttonType
        self.title = title
        self.alignment = alignment
        self.isDisable = isDisable
        self.maxWidth = maxWidth
        self.action = action
        self.leadingImage = leadingImage
        self.trailingImage = trailingImage
    }
    
    private var buttonContent: some View {
        HStack(spacing: 0) {
            if let image = leadingImage {
                Image(uiImage: image)
                    .renderingMode(.template)
                    .foregroundStyle(buttonConfiguration.titleColor)
                    .padding(.leading)
            }
            
            Text(title)
                .font(theme.fonts.semiBold(size: 14))
                .foregroundStyle(buttonConfiguration.titleColor)
                .padding(.vertical, 12)
                .padding(.horizontal, 12)
            
            if let image = trailingImage {
                Image(uiImage: image)
                    .renderingMode(.template)
                    .foregroundStyle(buttonConfiguration.titleColor)
                    .padding(.trailing)
            }

        }
        .frame(maxWidth: maxWidth ? .infinity : nil, alignment: alignment)
        .background(buttonConfiguration.backgroundColor)
        .overlay {
            if buttonConfiguration.showBorder {
                border
            }
        }
        .clipShape(
            RoundedRectangle(
                cornerRadius: buttonConfiguration.cornerRadius
            )
        )
    }
    
    private var border: some View {
        RoundedRectangle(cornerRadius: buttonConfiguration.cornerRadius)
            .inset(by: 0.5)
            .stroke(buttonConfiguration.borderColor, lineWidth: 1)
    }
    
    public var body: some View {
        Button(
            action: action,
            label: {
                buttonContent
            }
        )
        .opacity(buttonConfiguration.getOpacityOfBackground(isDisable))
        .disabled(isDisable)
    }
}

#Preview {
    EupButton(
        buttonType: .outlineButtonPrimaryColor,
        title: "Обновить",
        isDisable: true,
        action: {
            print("Click on button")
        }
    )
}

#Preview {
    EupButton(
        buttonType: .outlineButtonPrimaryColor,
        title: "Обновить",
        maxWidth: false,
        action: {
            print("Click on button")
        }
    )
}

#Preview("Only text button") {
    struct ButtonWithTextOnlyPreview: View {
        
        @Environment(\.theme) private var theme
        
        var body: some View {
            EupButton(
                buttonType: .withTextOnly(theme.surfaceGreen),
                title: "Обновить",
                maxWidth: true,
                action: {
                    print("Click on button")
                }
            )
        }
    }
    
    return ButtonWithTextOnlyPreview()
}
