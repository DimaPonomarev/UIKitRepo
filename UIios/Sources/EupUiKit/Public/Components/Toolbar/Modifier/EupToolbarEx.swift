//
//  EupToolbarEx.swift
//  EupUiKit
//
//  Created by Артём  on 27.02.2025.
//

import SwiftUI

public extension View {
    func setToolbar(
        leadingButtonImage: UIImage,
        trailingButtonImage: UIImage? = nil,
        centerTitle: String,
        isUserAvatar: Bool = false,
        trailingOnLeftButtonImage: UIImage? = nil,
        trailingDynamicTextButton: String? = nil,
        leadingAction: @escaping () -> Void,
        trailingAction: @escaping () -> Void = {},
        trailingOnLeftAction: @escaping () -> Void = {},
        trailingDynamicTextAction: @escaping () -> Void = {}
    ) -> some View {
        modifier(
            EupToolbar<EmptyView>(
                leadingButtonImage: leadingButtonImage,
                trailingButtonImage: trailingButtonImage,
                menuButtonsOnTrailing: nil,
                centerTitle: centerTitle,
                isUserAvatar: isUserAvatar,
                trailingOnLeftButtonImage: trailingOnLeftButtonImage,
                trailingDynamicTextButton: trailingDynamicTextButton,
                leadingAction: leadingAction,
                trailingAction: trailingAction,
                trailingOnLeftAction: trailingOnLeftAction,
                trailingDynamicTextAction: trailingDynamicTextAction
            )
        )
    }
    
    func setToolbarWithMenu(
        leadingButtonImage: UIImage,
        trailingButtonImage: UIImage? = nil,
        menuItems: some View,
        centerTitle: String,
        isUserAvatar: Bool = false,
        trailingOnLeftButtonImage: UIImage? = nil,
        trailingDynamicTextButton: String? = nil,
        leadingAction: @escaping () -> Void,
        trailingAction: @escaping () -> Void = {},
        trailingOnLeftAction: @escaping () -> Void = {},
        trailingDynamicTextAction: @escaping () -> Void = {}
    ) -> some View {
        modifier(
            EupToolbar(
                leadingButtonImage: leadingButtonImage,
                trailingButtonImage: trailingButtonImage,
                menuButtonsOnTrailing: menuItems,
                centerTitle: centerTitle,
                isUserAvatar: isUserAvatar,
                trailingOnLeftButtonImage: trailingOnLeftButtonImage,
                trailingDynamicTextButton: trailingDynamicTextButton,
                leadingAction: leadingAction,
                trailingAction: trailingAction,
                trailingOnLeftAction: trailingOnLeftAction,
                trailingDynamicTextAction: trailingDynamicTextAction
            )
        )
    }
}
