//
//  EupCapsuleView.swift
//  EupUiKit
//
//  Created by Артём  on 26.02.2025.
//

import SwiftUI

public struct EupCapsuleView<Content: View>: View {
    
    @Environment(\.theme) private var theme
    
    private var backgroundColor: Color
    private let content: () -> Content
    
    public init(
        backgroundColor: Color,
        content: @escaping () -> Content
    ) {
        self.backgroundColor = backgroundColor
        self.content = content
    }
    
    private var capsuleContent: some View {
        HStack {
            content()
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
        }
    }
    
    public var body: some View {
        capsuleContent
            .background(backgroundColor)
            .clipShape(
                RoundedRectangle(cornerRadius: 100)
            )
    }
}
