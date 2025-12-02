//
//  AlertConfig.swift
//  EupUiKit
//
//  Created by Артём  on 14.02.2025.
//

import SwiftUI

public struct AlertConfig {
    public var titleOfAlert: String = ""
    public var descriptionOfAlert: String = ""
    public var titleOfPrimaryButton: String = ""
    public var titleOfCancelButton: String = ""
    public var actionOfPrimaryButton: () -> Void = {}
    public var actionOfCancelButton: () -> Void = {}
    
    public init(
        titleOfAlert: String,
        descriptionOfAlert: String,
        titleOfPrimaryButton: String,
        titleOfCancelButton: String,
        actionOfPrimaryButton: @escaping () -> Void,
        actionOfCancelButton: @escaping () -> Void
    ) {
        self.titleOfAlert = titleOfAlert
        self.descriptionOfAlert = descriptionOfAlert
        self.titleOfPrimaryButton = titleOfPrimaryButton
        self.titleOfCancelButton = titleOfCancelButton
        self.actionOfPrimaryButton = actionOfPrimaryButton
        self.actionOfCancelButton = actionOfCancelButton
    }
}
