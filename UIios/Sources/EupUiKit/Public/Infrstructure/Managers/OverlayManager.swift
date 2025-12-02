//
//  StateManager.swift
//  EupUiKit
//
//  Created by Артём  on 14.02.2025.
//

import SwiftUI

@MainActor
public final class OverlayManager: ObservableObject {
    public static let shared = OverlayManager()
    
    @Published public var isShowAlert: Bool = false
    @Published public var isShowSnack: Bool = false
    @Published public var isLoading: Bool = false
    @Published public var alertConfig: AlertConfig? = nil
    @Published public var snackConfig: SnackConfig? = nil
    
    public func setLoading(_ bool: Bool) {
        isLoading = bool
    }
    
    public func setError() {
        // TODO: - Make error handle from state + Error Entity
    }
    
    public func showSnack(withConfig snackConfig: SnackConfig) {
        if self.snackConfig == nil {
            isShowSnack = true
            self.snackConfig = snackConfig
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                self.hideSnack()
            }
        }
    }
    
    public func showAlert(withConfig alertConfig: AlertConfig) {
        if self.alertConfig == nil {
            DispatchQueue.main.async {
                self.isShowAlert = true
                self.alertConfig = alertConfig
            }
        }
    }
    
    public func hideAlert() {
        isShowAlert = false
        alertConfig = nil
    }
    
    public func hideSnack() {
        isShowSnack = false
        snackConfig = nil
    }
}
