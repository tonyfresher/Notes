//
//  UIColorExtensionTests.swift
//  NotesTests
//
//  Created by Anton Fresher on 12.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import XCTest
import UIKit
@testable import Notes


class UIColorExtensionTests: XCTestCase {
    
    func testColorConversion() {
        let colorString = "#FFFFFFFF"
        if let color = UIColor(hex: colorString) {
            XCTAssertEqual(colorString, color.hexString)
        } else {
            XCTFail()
        }
    }

}
