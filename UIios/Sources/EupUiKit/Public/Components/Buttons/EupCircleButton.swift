//
//  EupCircleButton.swift
//  EupUiKit
//
//  Created by Артем Соловьев on 11.07.2025.
//

import SwiftUI

public struct EupCircleButton: View {
    
    @Environment(\.theme) private var theme
    
    private let iconForButton: UIImage
    private let sizeForCircleButton: CGFloat
    private let backgroundColor: Color
    private let action: () -> Void
    
    public init(
        iconForButton: UIImage,
        sizeForCircleButton: CGFloat,
        backgroundColor: Color,
        action: @escaping () -> Void
    ) {
        self.iconForButton = iconForButton
        self.sizeForCircleButton = sizeForCircleButton
        self.backgroundColor = backgroundColor
        self.action = action
    }
    
    public var body: some View {
        Button(
            action: action,
            label: {
                VStack {
                    Image(uiImage: iconForButton)
                        .frame(
                            width: 15,
                            height: 15
                        )
                }
                .frame(
                    width: sizeForCircleButton,
                    height: sizeForCircleButton
                )
                .background(backgroundColor)
            }
        )
        .clipShape(
            Circle()
        )
    }
}

#Preview {
    struct CircleButtonPreview: View {
        
        @Environment(\.theme) private var theme
        
        var body: some View {
            EupCircleButton(
                iconForButton: UIImage(systemName: "xmark")!,
                sizeForCircleButton: 40,
                backgroundColor: theme.informationGreen,
                action: {}
            )
        }
    }
    
    return CircleButtonPreview()
}
