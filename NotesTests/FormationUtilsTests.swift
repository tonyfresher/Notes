//
//  FormationUtilsTests.swift
//  NotesTests
//
//  Created by Anton Fresher on 12.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import XCTest
import UIKit
@testable import Notes


class FormationUtilsTests: XCTestCase {
    
    func testDateConversion() {
        let date = Date().withZeroNanoseconds
        let dateString = date.iso8601String
        let dateFromString = Date(iso8601String: dateString)
        XCTAssertEqual(date, dateFromString)
    }
    
    func testColorConversion() {
        let colorString = "#FFFFFF"
        if let color = UIColor(hexString: colorString) {
            XCTAssertEqual(colorString.lowercased(), color.hexString)
        } else {
            XCTFail()
        }
    }
}
