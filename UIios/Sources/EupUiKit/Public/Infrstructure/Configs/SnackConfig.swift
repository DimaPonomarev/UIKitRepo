//
//  SnackConfig.swift
//  EupUiKit
//
//  Created by Артём  on 18.02.2025.
//

import SwiftUI

public struct SnackConfig {
    public var snackType: SnackbarType
    public var title: String = ""
    public var description: String
    public var alignment: CustomSnackbarAlignment = .trailling
    public var applyButtonAction: (() -> Void)? = nil
    public var crossButtonAction: (() -> Void)? = nil
    
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
}
