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

extension UIColor {
    
    var hexString: String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
    
    convenience init?(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        
        let scanner = Scanner(string: hex)
        scanner.scanHexInt32(&int)
        
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
