//
//  SnackShowingModifier.swift
//  EupUiKit
//
//  Created by Артём  on 18.02.2025.
//

import SwiftUI

enum SnackState {
    case hide
    case show
}

public struct SnackShowingModifier: ViewModifier {
    
    @Binding private var isShowing: Bool
    @Binding private var snackConfig: SnackConfig?
    
    @State private var snackState: SnackState = .hide
    
    public init(
        isShowing: Binding<Bool>,
        snackConfig: Binding<SnackConfig?>
    ) {
        self._isShowing = isShowing
        self._snackConfig = snackConfig
    }
    
    public func body(content: Content) -> some View {
        content
            .overlay(
                alignment: snackConfig?.snackType != .info ? .top : .bottom,
                content: {
                    if isShowing {
                        if let snackConfig = snackConfig {
                            getSnackbar(config: snackConfig)
                                .shadow(radius: 15)
                                .padding(.top, 30)
                        }
                    }
                }
            )
            .animation(.linear(duration: 0.15), value: isShowing)
    }
    
    @ViewBuilder
    private func getSnackbar(config: SnackConfig) -> some View {
        Group {
            if let applyButtonAction = config.applyButtonAction {
                EupSnackbar(
                    snackType: config.snackType,
                    title: config.title,
                    description: config.description,
                    alignment: config.alignment,
                    applyButtonAction: applyButtonAction
                )
            } else if let crossButtonAction = config.crossButtonAction {
                EupSnackbar(
                    snackType: config.snackType,
                    title: config.title,
                    description: config.description,
                    crossButtonAction: crossButtonAction
                )
            } else {
                EupSnackbar(
                    snackType: config.snackType,
                    title: config.title,
                    description: config.description
                )
            }
        }
        .padding(16)
    }
}

public extension View {
    func setSnackbar(
        isShow: Binding<Bool>,
        snackConfig: Binding<SnackConfig?>
    ) -> some View {
        modifier(
            SnackShowingModifier(
                isShowing: isShow,
                snackConfig: snackConfig
            )
        )
    }
}
