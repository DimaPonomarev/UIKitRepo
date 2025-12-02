//
//  PhotoCellSelectionController.swift
//  EupUiKit
//
//  Created by Артем Соловьев on 24.11.2025.
//

import SwiftUI

final class PhotoCellSelectionController: ObservableObject {
    @Published var selected = Set<Int>()
    @Published var isDragging = false
    
    enum CellAction { case select, deSelect }
    var cellAction: CellAction = .select
    var alreadySelectedCell = Set<Int>()
    
    func startSelect(at index: Int?) {
        isDragging = true
        alreadySelectedCell.removeAll()
        if let i =  index {
            cellAction = selected.contains(i) ? .deSelect : .select
            applySelected(index: i)
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
    
    func applySelected(index: Int) {
        guard !alreadySelectedCell.contains(index) else { return }
        alreadySelectedCell.insert(index)
        switch cellAction {
        case .select: selected.insert(index)
        case .deSelect: selected.remove(index)
        }
    }
    
    func endSelect() {
        isDragging = false
        alreadySelectedCell.removeAll()
    }
}
