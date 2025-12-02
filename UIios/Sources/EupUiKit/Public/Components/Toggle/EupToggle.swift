//
//  EupToggle.swift
//  EupUiKit
//
//  Created by Артём  on 07.03.2025.
//

import SwiftUI

public struct EupToggle: View {
    
    @Environment(\.theme) private var theme
    
    @State private var isOn: Bool
    private var onChange: (Bool) -> Void
    
    public init(
        isOn: Bool,
        onChange: @escaping (Bool) -> Void
    ) {
        self.isOn = isOn
        self.onChange = onChange
    }
    
    public var body: some View {
        Toggle("", isOn: $isOn)
            .frame(maxWidth: 38)
            .tint(theme.primaryColor)
            .onChange(of: isOn) { _ in
                onChange(isOn)
            }
    }
}

#Preview {
    EupToggle(
        isOn: false,
        onChange: { _ in }
    )
}
