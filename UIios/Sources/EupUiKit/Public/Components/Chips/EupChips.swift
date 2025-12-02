//
//  EupChips.swift
//  EupUiKit
//
//  Created by Артём  on 26.02.2025.
//

import SwiftUI
import SharedApi

public struct EupChips<items: IEupChips>: View {
    
    @Environment(\.theme) private var theme
    
    @Binding private var itemsList: [items]
    private let clickOnChips: (items) -> Void
    
    public init(
        itemsList: Binding<[items]>,
        clickOnChips: @escaping (items) -> Void
    ) {
        self._itemsList = itemsList
        self.clickOnChips = clickOnChips
    }
    
    private var listOfChips: some View {
        ForEach(
            itemsList,
            id: \.idChips
        ) { chip in
            Button(
                action: {
                    clickOnChips(chip)
                },
                label: {
                    chipsButtonContent(
                        title: chip.titleChips,
                        isSelected: chip.isSelectedChips
                    )
                }
            )
            .animation(
                .smooth(duration: 0.15),
                value: chip.isSelectedChips
            )
        }
    }
    
    private var scrollContent: some View {
        HStack(spacing: 10) {
            listOfChips
        }
    }
    
    public var body: some View {
        ScrollView(.horizontal,
                   showsIndicators: false
        ) {
            scrollContent
        }
    }
    
    @ViewBuilder
    private func chipsButtonContent(
        title: String,
        isSelected: Bool
    ) -> some View {
        EupCapsuleView(
            backgroundColor: isSelected ? theme.primaryColor : theme.surfaceLightGray
        ) {
            Text(title)
                .font(
                    isSelected ? theme.fonts.semiBold(size: 12)
                    : theme.fonts.regular(size: 12)
                )
                .foregroundStyle(
                    isSelected ? theme.onPrimaryWhite
                    : theme.onSurfaceDarkGray
                )
        }
    }
}
//
//#Preview {
//    EupChips(
//        itemsList: .constant(Mock.getChips()),
//        clickOnChips: { _ in
//        }
//    )
//}
