//
//  ComponentCreaterHelper.swift
//  EupUiKit
//
//  Created by Артём  on 25.02.2025.
//

import SwiftUI
import EupUiKit

@MainActor
struct TestComponentFactory: @preconcurrency TestFactoryProtocol {
    
    static private let buttonTitle: String = "Button"
    static private let someString: String = "String"
    static private let buttonAction: () -> Void = {}
    
    // MARK: - Buttons
    static func createContainedPrimaryColorButton() -> EupButton? {
        EupButton(
            buttonType: .containedPrimaryColor,
            title: buttonTitle,
            action: buttonAction
        )
    }
    
    static func createOutlineGrayColorButton() -> EupButton? {
        EupButton(
            buttonType: .outlineButton,
            title: buttonTitle,
            action: buttonAction
        )
    }
    
    static func createOutlinePrimaryColorButton() -> EupButton? {
        EupButton(
            buttonType: .outlineButtonPrimaryColor,
            title: buttonTitle,
            action: buttonAction
        )
    }
    // MARK: - TextView
    static func createTextView() -> EupText? {
        EupText(
            fontType: .regular(14),
            text: buttonTitle
        )
    }
    
    // MARK: - Main surface bounce card cell
    static func createMainSurfaceBounceCardCell<Content: View>(
        contentInCard: @escaping() -> Content
    ) -> CardCell<Content>? {
        CardCell(
            actionOnTap: {},
            content: {
                contentInCard()
            }
        )
    }
    
    // MARK: - Checkboxes
    static func createSingleCheckbox() -> Checkbox? {
        Checkbox(
            isSelected: false
        )
    }
    
    static func createMultipleCheckbox() -> Checkbox? {
        Checkbox(
            isSelected: false,
            isMultiselect: true
        )
    }
    
    static func createSingleTextCheckbox() -> EupTextCheckbox? {
        EupTextCheckbox(
            isSelected: false,
            text: someString
        )
    }
    
    static func createMultipleTextCheckbox() -> EupTextCheckbox? {
        EupTextCheckbox(
            isSelected: false,
            text: someString,
            isMultiselect: true
        )
    }
    
    // MARK: - Textfield
    static func createFloatingTextfield() -> EupFloatingTextfield? {
        EupFloatingTextfield(
            text: .constant(someString),
            placeholder: someString
        )
    }
    
    // MARK: - Snackbars
    static func createInfoSnackBar() -> EupSnackbar? {
        EupSnackbar(
            snackType: .info,
            description: someString
        )
    }
    
    static func createErrorSnackBar() -> EupSnackbar? {
        EupSnackbar(
            snackType: .error,
            description: someString
        )
    }
    
    static func createSuccessSnackBar() -> EupSnackbar? {
        EupSnackbar(
            snackType: .success,
            description: someString
        )
    }
    
    // MARK: - Alert
    static func createAlert() -> EupAlert? {
        EupAlert(
            titleOfAlert: someString,
            descriptionOfAlert: someString,
            titleOfPrimaryButton: someString,
            titleOfCancelButton: someString,
            actionOfPrimaryButton: buttonAction,
            actionOfCancelButton: buttonAction
        )
    }
}
