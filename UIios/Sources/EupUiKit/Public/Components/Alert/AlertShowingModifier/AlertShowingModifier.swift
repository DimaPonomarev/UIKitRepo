//
//  AlertShowingModifier.swift
//  EupUiKit
//
//  Created by Артём  on 13.02.2025.
//

import SwiftUI

private enum AlertState {
    case hide
    case show
}

public struct AlertShowingModifier: ViewModifier {
    
    @Binding private var isShow: Bool
    @Binding private var alertConfig: AlertConfig?
    
    @State private var alertState: AlertState = .hide
    @State private var alertPosition: CGFloat = .zero
    
    public init(
        isShow: Binding<Bool>,
        alertConfig: Binding<AlertConfig?>
    ) {
        self._isShow = isShow
        self._alertConfig = alertConfig
    }
    
    private var overlayedView: some View {
        GeometryReader { gr in
            ZStack {
                Color.black
                    .opacity(isShow ? 0.37 : 0)
                    .ignoresSafeArea()
                    .allowsHitTesting(isShow)
                    .onTapGesture {
                        hideAlert()
                    }
                if let alertConfig = alertConfig {
                    EupAlert(
                        titleOfAlert: alertConfig.titleOfAlert,
                        descriptionOfAlert: alertConfig.descriptionOfAlert,
                        titleOfPrimaryButton: alertConfig.titleOfPrimaryButton,
                        titleOfCancelButton: alertConfig.titleOfCancelButton,
                        actionOfPrimaryButton: alertConfig.actionOfPrimaryButton,
                        actionOfCancelButton: hideAlert
                    )
                    .position(getPosition(with: gr))
                }
            }
        }
    }
    
    public func body(content: Content) -> some View {
        content
            .opacity(isShow ? 0.65 : 1)
            .overlay {
                if isShow {
                    overlayedView
                }
            }
            .onChange(of: isShow) { _ in
                if isShow {
                    showAlert()
                }
            }
            .animation(.smooth(duration: 0.25), value: isShow)
    }
    
    private func getPosition(with proxy: GeometryProxy) -> CGPoint {
        switch alertState {
        case .hide:
            return CGPoint(
                x: proxy.size.width / 2,
                y: -proxy.size.height / 2
            )
        case .show:
            return CGPoint(
                x: proxy.size.width / 2,
                y: proxy.size.height / 2
            )
        }
    }
    
    private func hideAlert() {
        Task {
            await MainActor.run {
                withAnimation(.smooth(duration: 0.4)) {
                    alertState = .hide
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        alertConfig?.actionOfCancelButton()
                    }
                }
            }
        }
    }
    
    private func showAlert() {
        Task {
            await MainActor.run {
                withAnimation(.smooth(duration: 0.4)) {
                    alertState = .show
                }
            }
        }
    }
}

public extension View {
    func setAlert(isShow: Binding<Bool>,
                  alertConfig: Binding<AlertConfig?>
    ) -> some View {
        modifier(
            AlertShowingModifier(
                isShow: isShow,
                alertConfig: alertConfig
            )
        )
    }
}

