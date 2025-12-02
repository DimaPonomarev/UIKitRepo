//
//  SnackbarTests.swift
//  EupUiKit
//
//  Created by Артём  on 26.02.2025.
//

import XCTest
import SwiftUI
@testable import EupUiKit

@MainActor
final class SnackbarTests: XCTestCase {
    func testErrorSnackbarInitialization() {
        let snackbar = TestComponentFactory.createErrorSnackBar()
        TestHelpers.checkOnNotNilWhenInitialized(component: snackbar)
    }
    
    func testSuccessSnackbarInitialization() {
        let snackbar = TestComponentFactory.createSuccessSnackBar()
        TestHelpers.checkOnNotNilWhenInitialized(component: snackbar)
    }
    
    func testInfoSnackbarInitialization() {
        let snackbar = TestComponentFactory.createInfoSnackBar()
        TestHelpers.checkOnNotNilWhenInitialized(component: snackbar)
    }
    
    func testSnackbarPerfomance() {
        measure {
            let listOfSnacks = ForEach(0..<5000) { _ in TestComponentFactory.createInfoSnackBar() }
            TestHelpers.createHostingController(fromView: listOfSnacks)
        }
    }
}
