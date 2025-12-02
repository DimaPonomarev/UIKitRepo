//
//  EupToolbar.swift
//  EupUiKit
//
//  Created by Артём  on 27.02.2025.
//

import SwiftUI

public struct EupToolbar<MenuItems>: ViewModifier where MenuItems: View {
    
    @Environment(\.theme) private var theme
    
    private let leadingButtonImage: UIImage
    private let trailingButtonImage: UIImage?
    private let centerTitle: String
    private let trailingOnLeftButtonImage: UIImage?
    private let trailingDynamicTextButton: String?
    private let leadingAction: () -> Void
    private var trailingAction: () -> Void = {}
    private var trailingOnLeftAction: () -> Void = {}
    private var trailingDynamicTextAction: () -> Void = {}
    private var isUserAvatar: Bool = false
    private var menuButtonsOnTrailing: MenuItems?
    
    public init(
        leadingButtonImage: UIImage,
        trailingButtonImage: UIImage? = nil,
        menuButtonsOnTrailing: MenuItems? = nil,
        centerTitle: String,
        isUserAvatar: Bool = false,
        trailingOnLeftButtonImage: UIImage? = nil,
        trailingDynamicTextButton: String? = nil,
        leadingAction: @escaping () -> Void,
        trailingAction: @escaping () -> Void = {},
        trailingOnLeftAction: @escaping () -> Void = {},
        trailingDynamicTextAction: @escaping () -> Void = {}
    ) {
        self.leadingButtonImage = leadingButtonImage
        self.trailingButtonImage = trailingButtonImage
        self.centerTitle = centerTitle
        self.trailingOnLeftButtonImage = trailingOnLeftButtonImage
        self.trailingDynamicTextButton = trailingDynamicTextButton
        self.leadingAction = leadingAction
        self.trailingAction = trailingAction
        self.trailingOnLeftAction = trailingOnLeftAction
        self.trailingDynamicTextAction = trailingDynamicTextAction
        self.isUserAvatar = isUserAvatar
        self.menuButtonsOnTrailing = menuButtonsOnTrailing
    }
    
    private var leadingButtonSUImage: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(
                action: leadingAction,
                label: {
                    if isUserAvatar {
                        Image(uiImage: leadingButtonImage)
                            .resizable()
                            .scaledToFit()
                            .frame(
                                width: 24,
                                height: 24
                            )
                            .clipShape(Circle())
                    } else {
                        Image(uiImage: leadingButtonImage)
                            .renderingMode(.template)
                            .frame(
                                width: 24,
                                height: 24
                            )
                            .foregroundStyle(theme.onSurfaceDarkGray)
                    }
                }
            )
            .unredacted()
        }
    }
    
    private var trailingButtonSUImage: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            if let menuItems = menuButtonsOnTrailing {
                Menu(
                    content: {
                        menuItems
                    },
                    label: {
                        Button(
                            action: trailingAction,
                            label: {
                                if let trailingButtonImage = trailingButtonImage {
                                    Image(uiImage: trailingButtonImage)
                                        .renderingMode(.template)
                                        .frame(
                                            width: 24,
                                            height: 24
                                        )
                                        .foregroundStyle(theme.onSurfaceDarkGray)
                                }
                            }
                        )
                    }
                )
                .unredacted()
            } else {
                if let trailingButtonImage = trailingButtonImage {
                    Button(
                        action: trailingAction,
                        label: {
                            Image(uiImage: trailingButtonImage)
                                .renderingMode(.template)
                                .frame(
                                    width: 24,
                                    height: 24
                                )
                                .foregroundStyle(theme.onSurfaceDarkGray)
                        }
                    )
                    .unredacted()
                }
            }
        }
    }
    
    private var trailingOnLefButtonSUImage: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            if let image = trailingOnLeftButtonImage {
                Button(
                    action: trailingOnLeftAction,
                    label: {
                            Image(uiImage: image)
                                .renderingMode(.template)
                                .frame(
                                    width: 24,
                                    height: 24
                                )
                                .foregroundStyle(theme.onSurfaceDarkGray)
                        }
                )
                .unredacted()
            }
        }
    }
    
    private var title: some ToolbarContent {
        ToolbarItem(
            placement: .principal,
            content: {
                EupText(
                    fontType: .semibold(16),
                    text: centerTitle
                )
                .multilineTextAlignment(.center)
                .unredacted()
            }
        )
    }
    
    private var textButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            if let text = trailingDynamicTextButton {
                Button(
                    action: trailingDynamicTextAction,
                    label: {
                        EupText(
                            fontType: .regular(14),
                            text: text,
                            foregroundColor: theme.onSurfaceLightBlue
                        )
                    }
                )
                .unredacted()
            }
        }
    }
    
    public func body(content: Content) -> some View {
        content
            .toolbar {
                leadingButtonSUImage
                title
                textButton
                trailingOnLefButtonSUImage
                trailingButtonSUImage
            }
            .navigationBarTitleDisplayMode(.inline)
//            .toolbarBackground(
//                theme.onSurfaceWhite,
//                for: .navigationBar
//            )
    }
}
