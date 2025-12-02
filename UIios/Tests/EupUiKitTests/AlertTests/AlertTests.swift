//
//  AlertTests.swift
//  EupUiKit
//
//  Created by Артём  on 26.02.2025.
//

import XCTest
import SwiftUI
@testable import EupUiKit

@MainActor
final class AlertTests: XCTestCase {
    func testAlertInitialization() {
        let alert = TestComponentFactory.createAlert()
        TestHelpers.checkOnNotNilWhenInitialized(component: alert)
    }
    
    func testAlertPerfomace() {
        measure {
            let alert = TestComponentFactory.createAlert()
            TestHelpers.createHostingController(fromView: alert)
        }
    }
}
