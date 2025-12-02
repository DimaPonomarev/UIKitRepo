//
//  EupCheckboxBottomSheet.swift
//  EupUiKit
//
//  Created by Артём  on 27.02.2025.
//

import SwiftUI
import SharedApi

@available(iOS 16.0, *)
public struct EupCheckboxBottomSheet<Item>: View where Item: IEupCheckboxCell {
    
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss
    
    private var listOfItems: [Item]
    private var titleOfSheet: String
    private var isMultiselect: Bool = false
    private var isSearchAvailible: Bool = false
    private var isResetButtonAvailible: Bool = false
    private var titleOfApplyButton: String
    private var titleOfResetButton: String
    private var tappedOnCell: (Item) -> Void
    private var applyAction: () -> Void
    private var resetAction: () -> Void
    private var searchAction: (String) -> Void
    private var loadMoreAction: () -> Void
    
    @State private var searchableText: String = ""
    
    public init(
        listOfItems: [Item],
        titleOfSheet: String,
        isMultiselect: Bool = false,
        isSearchAvailible: Bool = false,
        isResetButtonAvailible: Bool = false,
        titleOfApplyButton: String,
        titleOfResetButton: String = "",
        tappedOnCell: @escaping (Item) -> Void,
        applyAction: @escaping () -> Void,
        resetAction: @escaping () -> Void = {},
        searchAction: @escaping (String) -> Void = {_ in},
        loadMoreAction: @escaping () -> Void = {}
    ) {
        self.listOfItems = listOfItems
        self.titleOfSheet = titleOfSheet
        self.isMultiselect = isMultiselect
        self.tappedOnCell = tappedOnCell
        self.applyAction = applyAction
        self.titleOfApplyButton = titleOfApplyButton
        self.searchAction = searchAction
        self.isSearchAvailible = isSearchAvailible
        self.isResetButtonAvailible = isResetButtonAvailible
        self.titleOfResetButton = titleOfResetButton
        self.resetAction = resetAction
        self.loadMoreAction = loadMoreAction
    }
    
    private var listOfItemsContent: some View {
        ScrollView {
            LazyVStack {
                ForEach(
                    listOfItems,
                    id: \.idCell
                ) { item in
                    EupCheckboxCell(
                        cellModel: item,
                        isMultipleSelected: isMultiselect,
                        actionOnClick: { tappedItem in
                            tappedOnCell(tappedItem)
                        }
                    )
                    .onAppear {
                        if listOfItems.last?.idCell == item.idCell {
                            loadMoreAction()
                            print("IS LAST GO MORE")
                        }
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .frame(
            maxWidth: .infinity,
            minHeight: 10
        )
    }
    
    private var sheetContent: some View {
        VStack(alignment: .leading, spacing: 11) {
            VStack(alignment: .leading, spacing: 16) {
                EupText(
                    fontType: .semibold(18),
                    text: titleOfSheet
                )
                .foregroundStyle(theme.onSurfaceDarkGray)
                
                if isSearchAvailible {
                    EupSeachableTextField(searchText: $searchableText) { newValue in
                        searchAction(newValue)
                    } onClearButtonTap: {
                        //
                    } onSubmitTap: {
                        searchAction(searchableText)
                    }
                }
            }
            if listOfItems.isEmpty {
                VStack(
                    alignment: .center,
                    spacing: 14
                ) {
                    Spacer()
                    Image(systemName: "checklist")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(theme.onBackgroundLightGray)
                        .scaledToFit()
                        .frame(
                            width: 65,
                            height: 65
                        )
                    EupText(
                        fontType: .medium(20),
                        text: "Список пуст",
                        foregroundColor: theme.onBackgroundLightGray
                    )
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            } else {
                listOfItemsContent
            }
        }
        .background(theme.onSurfaceWhite)
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 10) {
                if isResetButtonAvailible {
                    EupButton(
                        buttonType: .outlineButtonPrimaryColor,
                        title: titleOfResetButton,
                        action: resetAction
                    )
                }
                EupButton(
                    buttonType: .containedPrimaryColor,
                    title: titleOfApplyButton,
                    action: {
                        applyAction()
                    }
                )
            }
            .padding(16)
            .background(theme.onSurfaceWhite)
        }
    }
    
    public var body: some View {
        sheetContent
            .presentationDragIndicator(.visible)
            .presentationDetents(
                isSearchAvailible ? [.medium, .large] : [.height(getDetentHeight())]
            )
            .animation(.bouncy(duration: 0.12), value: listOfItems.count)
    }
    
    private func getDetentHeight() -> CGFloat {
        let heightOfOneCell = 45
        let bottomSafeArea = 100
        let topSafeArea = 25
        let safeAreas = bottomSafeArea + topSafeArea
        let result = CGFloat(listOfItems.count * heightOfOneCell + safeAreas)
        return result
    }
}

struct EupCheckboxBottomSheetTest: View {
    
    let cellModelList = [CellModel(title: "first", isSelected: false), CellModel(title: "second", isSelected: true), CellModel(title: "third", isSelected: false), CellModel(title: "fourth", isSelected: false), CellModel(title: "fifth", isSelected: false)]
    
    var body: some View {
        Text("Hello, World!")
            .sheet(isPresented: .constant(true)) {
                if #available(iOS 16.0, *) {
                    EupCheckboxBottomSheet(listOfItems: cellModelList, titleOfSheet: "titleOfSheet", titleOfApplyButton: "titleOfApplyButton", tappedOnCell: { print("checkbox \($0.titleCell)") }, applyAction: { print("action")})
                } else {
                    Text("Ko")
                }
            }
    }
}

#Preview {
    EupCheckboxBottomSheetTest()
}
