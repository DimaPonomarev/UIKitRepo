//
//  PinButtonStyle.swift
//  EupUiKit
//
//  Created by Артём  on 06.03.2025.
//

import SwiftUI

struct PinButtonStyle: ButtonStyle {
    
    @Environment(\.theme) private var theme
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ?
                        theme.primaryColor.opacity(0.2).clipShape(Circle()) :
                            Color.clear.clipShape(Circle())
            )
    }
}
