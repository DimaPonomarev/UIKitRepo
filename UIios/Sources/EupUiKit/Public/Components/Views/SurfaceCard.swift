//
//  SurfaceCard.swift
//  EupUiKit
//
//  Created by Артём  on 19.02.2025.
//

import SwiftUI

public struct SurfaceCard<Content: View>: View {
    
    @Environment(\.theme) private var theme
    
    private var content: () -> Content
    private var surfaceColor: Color
    private var surfaceCornerRadius: CGFloat = 4
    private var surfacePadding: CGFloat = 12
    
    public init(
        surfaceColor: Color,
        surfaceCornerRadius: CGFloat = 4,
        surfacePadding: CGFloat = 12,
        content: @escaping () -> Content
    ) {
        self.content = content
        self.surfaceColor = surfaceColor
        self.surfaceCornerRadius = surfaceCornerRadius
    }
    
    public var body: some View {
        VStack {
            content()
                .padding(surfacePadding)
        }
        .frame(maxWidth: .infinity)
        .background(surfaceColor)
        .clipShape(
            RoundedRectangle(
                cornerRadius: surfaceCornerRadius
            )
        )
    }
}

#Preview {
    SurfaceCard(
        surfaceColor: .red,
        content: {
            Text("DS")
        }
    )
}
