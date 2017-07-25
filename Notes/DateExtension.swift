//
//  Date+ISO8601Conversion.swift
//  Notes
//
//  Created by Anton Fresher on 18.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation

extension Date {
    
    public var withZeroNanoseconds: Date {
        let calendar = NSCalendar.current
        var dateComponents = calendar.dateComponents(in: .current, from: self)
        dateComponents.nanosecond = 0
        
        return calendar.date(from: dateComponents)!
    }

}
