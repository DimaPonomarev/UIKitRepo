//
//  File.swift
//  EupUiKit
//
//  Created by Артём  on 12.02.2025.
//

import Foundation
import SwiftUI

struct FontsLoader {
    // Функция для загрузки кастомного шрифта
    static func loadCustomFont(
        name: String,
        size: CGFloat
    ) -> Font {
        guard (UIFont(name: name, size: size) != nil) else {
            registerFont(name: name)
            return Font.custom(name, size: size)
        }
        return Font.custom(name, size: size)
    }
    // Функция регистрации шрифтов
    static private func registerFont(name: String) {
        guard let fontURL = Bundle.module.url(forResource: name, withExtension: "otf"),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider) else {
            print("⚠️ Ошибка: не удалось загрузить шрифт \(name)")
            return
        }

        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            print("⚠️ Ошибка регистрации шрифта \(name): \(error.debugDescription)")
        } else {
            print("✅ Шрифт \(name) загружен успешно")
        }
    }
}
