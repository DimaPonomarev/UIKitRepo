//
//  EupAlert.swift
//  EupUiKit
//
//  Created by Артём  on 13.02.2025.
//

import SwiftUI

public struct EupAlert: View {
    
    @Environment(\.theme) private var theme
    
    private var titleOfAlert: String
    private var descriptionOfAlert: String
    private var titleOfPrimaryButton: String
    private var titleOfCancelButton: String
    private var actionOfPrimaryButton: () -> Void
    private var actionOfCancelButton: () -> Void
    
    public init(
        titleOfAlert: String,
        descriptionOfAlert: String,
        titleOfPrimaryButton: String,
        titleOfCancelButton: String,
        actionOfPrimaryButton: @escaping () -> Void,
        actionOfCancelButton: @escaping () -> Void
    ) {
        self.titleOfPrimaryButton = titleOfPrimaryButton
        self.titleOfCancelButton = titleOfCancelButton
        self.actionOfPrimaryButton = actionOfPrimaryButton
        self.actionOfCancelButton = actionOfCancelButton
        self.descriptionOfAlert = descriptionOfAlert
        self.titleOfAlert = titleOfAlert
    }
    
    private var descriptionOfAlertText: some View {
        Text(descriptionOfAlert)
            .font(theme.fonts.regular(size: 14))
            .foregroundStyle(theme.onSurfaceDarkGray)
            .multilineTextAlignment(.center)
    }
    
    private var titleOfAlertText: some View {
        Text(titleOfAlert)
            .font(theme.fonts.semiBold(size: 18))
            .foregroundStyle(theme.onSurfaceDarkGray)
            .multilineTextAlignment(.center)
    }
    
    private var textStack: some View {
        VStack(spacing: 8) {
            titleOfAlertText
            descriptionOfAlertText
        }
    }
    
    private var buttonHorizontalStack: some View {
        HStack(spacing: 12) {
            EupButton(
                buttonType: .outlineButton,
                title: titleOfCancelButton,
                action: actionOfCancelButton
            )
            EupButton(
                buttonType: .containedPrimaryColor,
                title: titleOfPrimaryButton,
                action: actionOfPrimaryButton
            )
        }
    }
    
    private var alertView: some View {
        VStack(spacing: 24) {
            textStack
            buttonHorizontalStack
        }
        .padding(16)
        .background(theme.surfaceColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    public var body: some View {
        alertView
            .padding(16)
    }
}

#Preview {
    EupAlert(
        titleOfAlert: "Вы уже забронировали место 627.6 на выбранную дату",
        descriptionOfAlert: "Если вы продолжите бронирование, предыдущая бронь отменится",
        titleOfPrimaryButton: "Да, продолжить",
        titleOfCancelButton: "Отмена",
        actionOfPrimaryButton: {},
        actionOfCancelButton: {}
    )
}
