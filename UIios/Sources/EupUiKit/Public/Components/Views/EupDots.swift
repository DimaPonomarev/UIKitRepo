//
//  EupDots.swift
//  EupUiKit
//
//  Created by Артём  on 06.03.2025.
//

import SwiftUI

struct Shake: GeometryEffect {
    let amount: CGFloat = 10
    let shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
            CGAffineTransform(
                translationX:
                    amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                y: 0
            )
        )
    }
}

public struct EupDots: View {
    
    @Environment(\.theme) private var theme
    
    private var currentPinSize: Binding<Int>
    private var isError: Binding<Bool>
    private let titleOfPin: String
    
    public init(
        currentPinSize: Binding<Int>,
        isError: Binding<Bool>,
        titleOfPin: String
    ) {
        self.currentPinSize = currentPinSize
        self.titleOfPin = titleOfPin
        self.isError = isError
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            EupText(
                fontType: .semibold(16),
                text: titleOfPin
            )
            HStack(spacing: 12) {
                ForEach(0..<4) { currentPosition in
                    Circle()
                        .fill(
                            currentPosition < currentPinSize.wrappedValue ? theme.primaryColor : theme.surfaceLightGray
                        )
                        .frame(
                            width: 14,
                            height: 14
                        )
                }
            }
            .modifier(
                Shake(
                    animatableData: isError.wrappedValue ? 12 : 0
                )
            )
        }
        .animation(.smooth(duration: 0.13), value: currentPinSize.wrappedValue)
    }
}
