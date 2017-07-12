//
//  FormationUtils.swift
//  Notes
//
//  Created by Anton Fresher on 12.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation
import UIKit


extension Date {
    
    var iso8601String: String {
        return ISO8601DateFormatter()
            .string(from: self)
    }
    
    init?(iso8601String: String) {
        let date = ISO8601DateFormatter()
            .date(from: iso8601String)
        
        guard date != nil else {
            return nil
        }
        self = date!
    }
    
    public var withZeroNanoseconds: Date {
        let calendar = NSCalendar.current
        var dateComponents = calendar.dateComponents(in: .current, from: self)
        dateComponents.nanosecond = 0
        return calendar.date(from: dateComponents)!
    }
}
