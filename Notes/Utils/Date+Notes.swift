//
//  Date+ISO8601Conversion.swift
//  Notes
//
//  Created by Anton Fresher on 18.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation

extension Date {
    
    static func equalsWithoutNanoseconds(_ left: Date?, _ right: Date?) -> Bool {
        if left == nil && right == nil {
            return true
        }
        
        if let leftUnwrapped = left,
            let rightUnwrapped = right {
            return Int(leftUnwrapped.timeIntervalSince(rightUnwrapped)) == 0
        }
        
        return false
    }
}
