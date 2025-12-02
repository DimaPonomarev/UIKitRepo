//
//  WeekDays.swift
//  EupUiKit
//
//  Created by Артём  on 10.04.2025.
//

import Foundation
import SwiftUI

public enum WeekDaysEnum: CaseIterable, Hashable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    public var title: String {
        switch self {
        case .sunday:
            "Вс"
        case .monday:
            "Пн"
        case .tuesday:
            "Вт"
        case .wednesday:
            "Ср"
        case .thursday:
            "Чт"
        case .friday:
            "Пт"
        case .saturday:
            "Сб"
        }
    }
}
