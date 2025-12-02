//
//  RangeSelection.swift
//  EupUiKit
//
//  Created by Артём  on 14.04.2025.
//

import SwiftUI

public extension View {
    @ViewBuilder
    func setRangeLineSelection(
        dateRange: [Date],
        currentDate: Date
    ) -> some View {
        modifier(
            RangeSelection(
                dateRange: dateRange,
                currentDate: currentDate
            )
        )
    }
}

public struct RangeSelection: ViewModifier {
    
    @Environment(\.theme) private var theme
    
    enum TypeOfRangeDateSelection {
        case start
        case end
        case middle
        case noDate
    }
    
    private let dateRange: [Date]
    private let currentDate: Date
    
    public init(
        dateRange: [Date],
        currentDate: Date
    ) {
        self.dateRange = dateRange
        self.currentDate = currentDate
    }
    
    private var firstDate: Date {
        guard let date = dateRange.first else { return Date() }
        return date
    }
    
    private var lastDate: Date {
        guard let date = dateRange.last else { return Date() }
        return date
    }
    
    private var range: ClosedRange<Date> {
        firstDate...lastDate
    }
    
    private var typeOfDate: TypeOfRangeDateSelection {
        if range.contains(currentDate) {
            if currentDate == firstDate {
                return .start
            } else if currentDate == lastDate {
                return .end
            } else {
                return .middle
            }
        }
        return .noDate
    }
    
    public func body(content: Content) -> some View {
        switch typeOfDate {
        case .start:
            content
                .foregroundStyle(theme.onSurfaceWhite)
                .background(
                    theme.primaryColor
                        .clipShape(Circle())
                )
                .background(
                    isSecondDateHasSelectionForColor()
                        .cornerRadius(30, corners: [.topLeft, .bottomLeft])
                        .padding(.leading, 10)
                )
        case .end:
            content
                .background(
                    theme.primaryColor
                        .clipShape(Circle())
                )
                .background(
                    isSecondDateHasSelectionForColor()
                        .cornerRadius(30, corners: [.topRight, .bottomRight])
                        .padding(.trailing, 10)
                )
        case .middle:
            content
                .background(theme.primaryColor.opacity(0.25))
        case .noDate:
            content
                .background(Color.clear)
        }
    }
    
    private func isSecondDateHasSelectionForColor() -> Color {
        if dateRange.count > 1 {
            return theme.primaryColor.opacity(0.25)
        } else {
            return Color.clear
        }
    }
}
