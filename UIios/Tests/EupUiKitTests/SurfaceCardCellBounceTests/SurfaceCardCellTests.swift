//
//  File.swift
//  EupUiKit
//
//  Created by Артём  on 25.02.2025.
//

import XCTest
import SwiftUI
@testable import EupUiKit

@MainActor
final class SurfaceCardCellBounceTests: XCTestCase {
    func testMainSurfaceBounceCardWithEupTextInitialization() {
        let cell: CardCell? = TestComponentFactory.createMainSurfaceBounceCardCell(
            contentInCard: TestComponentFactory.createTextView
        )
        TestHelpers.checkOnNotNilWhenInitialized(component: cell)
    }
    
    func testMainSurfaceBounceCardWithEupTextPerfomance() throws {
        measure {
            let bounceCard = ForEach(0..<5000) { _ in
                TestComponentFactory.createMainSurfaceBounceCardCell(
                    contentInCard: TestComponentFactory.createTextView
                )
            }
            TestHelpers.createHostingController(fromView: bounceCard)
        }
    }
}
