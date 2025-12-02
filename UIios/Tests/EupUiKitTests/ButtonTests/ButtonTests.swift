//
//  ButtonTests.swift
//  EupUiKit
//
//  Created by Артём  on 25.02.2025.
//

import XCTest
import SwiftUI
@testable import EupUiKit

@MainActor
final class ButtonTests: XCTestCase {
    func testButtonPrimaryInitialization() {
        let button = TestComponentFactory.createContainedPrimaryColorButton()
        TestHelpers.checkOnNotNilWhenInitialized(component: button)
    }
    
    func testButtonOutlineGrayInitialization() {
        let button = TestComponentFactory.createOutlineGrayColorButton()
        TestHelpers.checkOnNotNilWhenInitialized(component: button)
    }
    
    func testButtonOutlinePrimaryInitialization()  {
        let button = TestComponentFactory.createOutlinePrimaryColorButton()
        TestHelpers.checkOnNotNilWhenInitialized(component: button)
    }
    
    func testButtonPerfomance() throws {
        measure {
            let button = TestComponentFactory.createContainedPrimaryColorButton()
            TestHelpers.createHostingController(fromView: button)
        }
    }
    
    func testFewButtonsPerfomance() throws {
        measure {
            let buttons = ForEach(0..<5000) { _ in
                TestComponentFactory.createContainedPrimaryColorButton()
            }
            TestHelpers.createHostingController(fromView: buttons)
        }
    }
}
