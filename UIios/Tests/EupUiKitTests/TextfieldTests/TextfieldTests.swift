//
//  TextfieldTests.swift
//  EupUiKit
//
//  Created by Артём  on 26.02.2025.
//

import XCTest
import SwiftUI
@testable import EupUiKit

@MainActor
final class TextfieldTests: XCTestCase {
    func testTextfieldInititialization() {
        let textField = TestComponentFactory.createFloatingTextfield()
        TestHelpers.checkOnNotNilWhenInitialized(component: textField)
    }
    
    func testTextfieldPerfomance() {
        measure {
            let listOfTextfields = ForEach(0..<5000) { _ in TestComponentFactory.createFloatingTextfield() }
            TestHelpers.createHostingController(fromView: listOfTextfields)
        }
    }
}
