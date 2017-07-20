//
//  Date+ISO8601Conversion.swift
//  Notes
//
//  Created by Anton Fresher on 18.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation

extension Date {
    
    public var iso8601String: String {
        return ISO8601DateFormatter().string(from: self)
    }
    
    public var withZeroNanoseconds: Date {
        let calendar = NSCalendar.current
        var dateComponents = calendar.dateComponents(in: .current, from: self)
        dateComponents.nanosecond = 0
        
        return calendar.date(from: dateComponents)!
    }
    
    init?(iso8601String: String) {
        let date = ISO8601DateFormatter()
            .date(from: iso8601String)
        
        guard date != nil else {
            return nil
        }
        self = date!
    }

}
