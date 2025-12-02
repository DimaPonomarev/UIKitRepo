//
//  EupPinButton.swift
//  EupUiKit
//
//  Created by Артём  on 06.03.2025.
//

import SwiftUI

public struct EupPinButton: View {
    
    @Environment(\.theme) private var theme
    
    private var isText: Bool = true
    private var titleButton: String = ""
    private var imageButton: UIImage = .remove
    private let buttonTapAction: () -> Void
    
    public init(
        isText: Bool = true,
        titleButton: String = "",
        imageButton: UIImage = .remove,
        buttonTapAction: @escaping () -> Void
    ) {
        self.isText = isText
        self.titleButton = titleButton
        self.imageButton = imageButton
        self.buttonTapAction = buttonTapAction
    }
    
    public var body: some View {
        Button(
            action: buttonTapAction,
            label: {
                if isText {
                    Text(titleButton)
                        .font(theme.fonts.regular(size: 28))
                        .foregroundStyle(theme.onBackgroundDarkGray)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                } else {
                    Image(uiImage: imageButton)
                        .resizable()
                        .renderingMode(.template)
                        .tint(theme.onBackgroundDarkGray)
                        .scaledToFit()
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: 26
                        )
                        .padding(.vertical, 20)
                }
            }
        )
        .buttonStyle(PinButtonStyle())
    }
}
