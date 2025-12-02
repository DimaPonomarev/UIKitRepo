//
//  EupSnackbar.swift
//  EupUiKit
//
//  Created by Артём  on 17.02.2025.
//

import SwiftUI

public struct EupSnackbar: View {
    @Environment(\.theme) private var theme
    
    private let snackType: SnackbarType
    private var title: String = ""
    private let description: String
    private var alignment: CustomSnackbarAlignment = .trailling
    private var applyButtonAction: (() -> Void)? = nil
    private var crossButtonAction: (() -> Void)? = nil
    
    private var snackConfiguration: SnackbarConfiguration {
        SnackbarConfiguration(
            theme: theme,
            snackType: snackType
        )
    }
    
    private var crossAction: () -> Void {
        if let action = crossButtonAction {
            return action
        }
        
        return {}
    }
    
    private var applyAction: () -> Void {
        if let action = applyButtonAction {
            return action
        }
        
        return {}
    }
    
    private var buttonsAlignmentInHorizontalStack: VerticalAlignment {
        if crossButtonAction != nil {
            return .top
        }
        
        if applyButtonAction != nil {
            return .center
        }
        
        return .top
    }
    
    /// Инициализатор, который создает компонент без кнопок
    /// - Parameters:
    ///   - snackType: вид компонента
    ///   - title: заголовок
    ///   - description: описание (обязательно)
    public init(
        snackType: SnackbarType,
        title: String = "",
        description: String
    ) {
        self.snackType = snackType
        self.title = title
        self.description = description
    }
    
    /// Инициализатор, который создает компонент с кнопкой "понятно"
    /// - Parameters:
    ///   - snackType: вид компонента
    ///   - title: заголовок
    ///   - description: описание (обязательно)
    ///   - alignment: расположение кнопки (справа или внизу справа)
    ///   - applyButtonAction: действие на кнопку
    public init(
        snackType: SnackbarType,
        title: String = "",
        description: String,
        alignment: CustomSnackbarAlignment = .trailling,
        applyButtonAction: @escaping () -> Void
    ) {
        self.snackType = snackType
        self.title = title
        self.description = description
        self.alignment = alignment
        self.applyButtonAction = applyButtonAction
    }
    
    /// Инициализатор, который создает компонент с кнопкой "крестик" на закрытие
    /// - Parameters:
    ///   - snackType: вид компонента
    ///   - title: заголовок
    ///   - description: описание (обязательно)
    ///   - crossButtonAction: действие на кнопку
    public init(
        snackType: SnackbarType,
        title: String = "",
        description: String,
        crossButtonAction: @escaping () -> Void
    ) {
        self.snackType = snackType
        self.title = title
        self.description = description
        self.crossButtonAction = crossButtonAction
    }
    
    private var descriptionText: some View {
        Text(description)
            .font(theme.fonts.regular(size: 14))
            .foregroundStyle(snackConfiguration.textColor)
            .multilineTextAlignment(.leading)
    }
    
    private var titleText: some View {
        Text(title)
            .font(theme.fonts.semiBold(size: 14))
            .foregroundStyle(snackConfiguration.textColor)
    }
    
    private var textVerticalStack: some View {
        VStack(
            spacing: 8
        ) {
            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                if !title.isEmpty {
                    titleText
                }
                descriptionText
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if alignment == .bottomTrailling {
                HStack {
                    Spacer()
                    applyButton
                }
            }
        }
    }
    
    private var crossButton: some View {
        Button(
            action: crossAction,
            label: {
                Image(systemName: "xmark")
                    .font(theme.fonts.semiBold(size: 16))
                    .foregroundStyle(theme.onSurfaceLightGray)
            }
        )
    }
    
    private var applyButton: some View {
        EupButton(
            buttonType: .outlineButtonPrimaryColor,
            title: "Понятно",
            action: applyAction
        )
        .frame(width: 110)
    }
    
    private var snackContent: some View {
        HStack(alignment: buttonsAlignmentInHorizontalStack) {
            textVerticalStack
            Spacer()
            getButtons()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(snackConfiguration.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: snackConfiguration.cornerRadius))
    }
    
    public var body: some View {
        snackContent
    }
    
    @ViewBuilder
    private func getButtons() -> some View {
        if crossButtonAction != nil {
            crossButton
        } else if applyButtonAction != nil && alignment == .trailling {
            applyButton
        }
    }
}

#Preview {
    VStack(spacing: 10) {
        EupSnackbar(
            snackType: .success,
            description: "Успех"
        )
        
        EupSnackbar(
            snackType: .error,
            description: "Ошибка"
        )
        
        EupSnackbar(
            snackType: .info,
            description: "Какая-то инфа"
        )
        
        EupSnackbar(
            snackType: .info,
            title: "Заголовок",
            description: "Какая-то инфа с заголовком"
        )
        
        EupSnackbar(
            snackType: .info,
            title: "Заголовок",
            description: "Какая-то инфа с заголовком и крестиком",
            crossButtonAction: {}
        )
        
        EupSnackbar(
            snackType: .info,
            description: "Какая-то инфа с кнопкой Какая-то инфа с кнопкой кнопкой кнопкой",
            applyButtonAction: {}
        )
        
        EupSnackbar(
            snackType: .info,
            title: "Заголовок",
            description: "Какая-то инфа с кнопкой внизу и заголовком Какая-то инфа с кнопкой внизу и заголовком Какая-то инфа с кнопкой внизу и заголовком Какая-то инфа с кнопкой внизу и заголовком заголовком заголовком заголовкомзаголов",
            alignment: .bottomTrailling,
            applyButtonAction: {}
        )
    }
    .padding(.horizontal, 16)
}
