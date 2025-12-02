//
//  TestFactoryProtocol.swift
//  EupUiKit
//
//  Created by Артём  on 25.02.2025.
//

import SwiftUI
import EupUiKit

protocol TestFactoryProtocol {
    static func createContainedPrimaryColorButton() -> EupButton?
    static func createOutlineGrayColorButton() -> EupButton?
    static func createOutlinePrimaryColorButton() -> EupButton?
    
    static func createTextView() -> EupText?
    
    static func createMainSurfaceBounceCardCell<Content: View>(
        contentInCard: @escaping() -> Content
    ) -> CardCell<Content>?
    
    static func createSingleCheckbox() -> Checkbox?
    static func createMultipleCheckbox() -> Checkbox?
    static func createSingleTextCheckbox() -> EupTextCheckbox?
    static func createMultipleTextCheckbox() -> EupTextCheckbox?
    
    static func createFloatingTextfield() -> EupFloatingTextfield?
    
    static func createErrorSnackBar() -> EupSnackbar?
    static func createSuccessSnackBar() -> EupSnackbar?
    static func createInfoSnackBar() -> EupSnackbar?
    
    static func createAlert() -> EupAlert?
}
