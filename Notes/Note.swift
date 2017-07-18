//
//  Note.swift
//  Notes
//
//  Created by Anton Fresher on 11.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation
import UIKit

// MARK: Note DTO

public struct Note: Equatable, CustomStringConvertible {
    
    public static let defaultColor = UIColor(hexString: "#ffffff")!
    
    public let uuid: String
    
    public var title: String
    public var content: String
    public var color: UIColor
    public var erasureDate: Date?
    
    init(uuid: String = UUID().uuidString,
         title: String = "",
         content: String = "",
         color: UIColor = defaultColor,
         erasureDate: Date? = nil) {
        self.uuid = uuid
        self.title = title
        self.content = content
        self.color = color
        self.erasureDate = erasureDate?.withZeroNanoseconds
    }
    
    public var isEmpty: Bool {
        return title == "" && content == "" && color == Note.defaultColor && erasureDate == nil
    }
    
    // MARK: Equatable support
    
    public static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.uuid == rhs.uuid &&
            lhs.title == rhs.title &&
            lhs.content == rhs.content &&
            lhs.color == rhs.color &&
            lhs.erasureDate == rhs.erasureDate
    }
    
    public static func != (lhs: Note, rhs: Note) -> Bool {
        return !(lhs == rhs)
    }
    
    // MARK: CustomStringConvertible support
    
    public var description: String {
        return String(describing: json)
    }
}
