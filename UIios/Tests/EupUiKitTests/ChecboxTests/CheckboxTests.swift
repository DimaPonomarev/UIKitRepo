//
//  CheckboxTests.swift
//  EupUiKit
//
//  Created by Артём  on 26.02.2025.
//

import XCTest
import SwiftUI
@testable import EupUiKit

@MainActor
final class CheckboxTests: XCTestCase {
    func testSingleCheckboxInitialization() {
        let checkbox = TestComponentFactory.createSingleCheckbox()
        TestHelpers.checkOnNotNilWhenInitialized(component: checkbox)
    }
    
    func testMultipleCheckboxInitialization() {
        let checkbox = TestComponentFactory.createMultipleCheckbox()
        TestHelpers.checkOnNotNilWhenInitialized(component: checkbox)
    }
    
    func testSingleTextCheckboxInitialization() {
        let checkbox = TestComponentFactory.createSingleTextCheckbox()
        TestHelpers.checkOnNotNilWhenInitialized(component: checkbox)
    }
    
    func testMultipleTextCheckboxInitialization() {
        let checkbox = TestComponentFactory.createMultipleTextCheckbox()
        TestHelpers.checkOnNotNilWhenInitialized(component: checkbox)
    }
    
    func testCheckboxPerfomance() {
        measure {
            let checkBox = ForEach(0..<5000) { _ in TestComponentFactory.createSingleCheckbox() }
            TestHelpers.createHostingController(fromView: checkBox)
        }
    }
}
