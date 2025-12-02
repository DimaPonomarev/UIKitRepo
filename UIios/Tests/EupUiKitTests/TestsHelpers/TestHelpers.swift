//
//  File.swift
//  EupUiKit
//
//  Created by Артём  on 25.02.2025.
//

import XCTest
import SwiftUI

struct TestHelpers {
    static func checkOnNotNilWhenInitialized(component: (some View)?) {
        XCTAssertNotNil(
            component,
            "Something component was not init"
        )
    }
    
    static func createHostingController(fromView: some View) {
        let controller = UIHostingController(rootView: fromView)
        XCTAssertNotNil(
            controller,
            "Something controller component was not init"
        )
    }
}
