//
//  CardCell.swift
//  EupUiKit
//
//  Created by Артём  on 18.02.2025.
//

import SwiftUI

struct BounceStyle: ButtonStyle {
    
    private var longPressTime: TimeInterval
    private var actionOnLongPress: () -> Void
    
    @State private var isPressed: Bool = false
    @State private var longPressDate = Date()
    
    init(
        longPressTime: TimeInterval,
        actionOnLongPress: @escaping () -> Void,
        longPressDate: Date = Date()
    ) {
        self.longPressTime = longPressTime
        self.actionOnLongPress = actionOnLongPress
        self.longPressDate = longPressDate
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(isPressed ? 0.9 : 1)
            .animation(
                .bouncy(duration: 0.40),
                value: isPressed
            )
            .onChange(of: configuration.isPressed) { newValue in
                longPressDate = Date()
                if newValue {
                    isPressed = newValue
                    tryTriggerLongPressAfterDelay(triggered: longPressDate)
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isPressed = false
                    }
                }
            }
    }
}

private extension BounceStyle {
    func tryTriggerLongPressAfterDelay(triggered date: Date) {
        DispatchQueue.main.asyncAfter(deadline: .now() + longPressTime) {
            guard date == longPressDate else { return }
            actionOnLongPress()
        }
    }
}

public struct CardCell<Content: View>: View {
    
    @Environment(\.theme) private var theme
    
    @State private var isPressed: Bool = false
    
    private var cardPadding: CGFloat = 16
    private var longPressTime: TimeInterval = 0.3
    private let content: () -> Content
    private let actionOnTap: () -> Void
    private var actionOnLongPress: () -> Void = {}
    
    public init(
        cardPadding: CGFloat = 16,
        longPressTime: TimeInterval = 0.3,
        actionOnTap: @escaping () -> Void,
        actionOnLongPress: @escaping () -> Void = {},
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
        self.actionOnTap = actionOnTap
        self.cardPadding = cardPadding
        self.longPressTime = longPressTime
        self.actionOnLongPress = actionOnLongPress
    }
    
    public var body: some View {
        Button(
            action: {
                isPressed = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isPressed = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                    actionOnTap()
                }
            },
            label: {
                Group {
                    content()
                        .padding(cardPadding)
                }
                .frame(maxWidth: .infinity)
                .background(theme.onSurfaceWhite)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 12
                    )
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .inset(by: 0.5)
                        .stroke(
                            theme.surfaceLightGray,
                            lineWidth: 1
                        )
                }
                .shadow(
                    color: .black.opacity(0.06),
                    radius: 4,
                    x: 0,
                    y: 4
                )
            }
        )
        .buttonStyle(
            BounceStyle(
                longPressTime: longPressTime,
                actionOnLongPress: actionOnLongPress
            )
        )
        .scaleEffect(isPressed ? 0.9 : 1)
        .animation(.bouncy(duration: 0.40), value: isPressed)
    }
}

#Preview {
    CardCell(
        cardPadding: 16,
        actionOnTap: { print("default tap") },
        content: {
            Text("TAP ME")
        }
    )
}
