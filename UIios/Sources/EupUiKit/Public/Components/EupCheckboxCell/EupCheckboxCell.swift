//
//  EupCheckboxCell.swift
//  EupUiKit
//
//  Created by Артём  on 27.02.2025.
//

import SwiftUI
import SharedApi

struct EupCheckboxCell<Model: IEupCheckboxCell>: View {
    
    private var cellModel: Model
    private var isMultipleSelected: Bool
    private var titleFont: TypeOfTextTitleFontCheckbox = .regular
    private let actionOnClick: (Model) -> Void
    
    public init(
        cellModel: Model,
        isMultipleSelected: Bool,
        titleFont: TypeOfTextTitleFontCheckbox = .regular,
        actionOnClick: @escaping (Model) -> Void
    ) {
        self.cellModel = cellModel
        self.isMultipleSelected = isMultipleSelected
        self.actionOnClick = actionOnClick
        self.titleFont = titleFont
    }
    
    public var body: some View {
        EupTextCheckbox(
            isSelected: cellModel.isSelectedCell,
            text: cellModel.titleCell,
            subTitle: cellModel.subTitleCell ?? "",
            isMultiselect: isMultipleSelected,
            titleFont: titleFont,
            onChecked: { _ in actionOnClick(cellModel) }
        )
        .padding(.vertical, 10)
    }
}


class CellModel: IEupCheckboxCell {
    
    var idCell: Int32 = Int32.random(in: 0...1000000)
    var isSelectedCell: Bool = false
    var subTitleCell: String?
    var titleCell: String
    
    init( title: String, isSelected: Bool) {
        self.titleCell = title
        self.isSelectedCell = isSelected
    }
}

#Preview {
    EupCheckboxCell(
        cellModel: CellModel(
            title: "first sub",
            isSelected: false
        ),
        isMultipleSelected: false,
        actionOnClick: { cell in
            print(cell)
        }
    )
}


