//
//  PhotoOpenner.swift
//  EupUiKit
//
//  Created by Артем Соловьев on 28.10.2025.
//

import SwiftUI

public struct PhotoOpenner: View {
    
    @Environment(\.theme) private var theme
    
    private var image: UIImage
    private var isScreenShot: Bool
    private var close: () -> Void
    private var choose: () -> Void
    
    public init(
        image: UIImage,
        isScreenShot: Bool,
        close: @escaping () -> Void,
        choose: @escaping () -> Void
    ) {
        self.image = image
        self.close = close
        self.choose = choose
        self.isScreenShot = isScreenShot
    }
    
    public var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                Spacer()
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                Spacer()
            }
        }
        .overlay(alignment: .bottom) {
            HStack {
                EupButton(
                    buttonType: .withTextOnly(theme.primaryColor),
                    title: "Выбрать",
                    alignment: .center,
                    action: {
                        close()
                        choose()
                    }
                )
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(theme.surfaceDark.opacity(0.85))
        }
    }
}
