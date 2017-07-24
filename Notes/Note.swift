//
//  Note.swift
//  Notes
//
//  Created by Anton Fresher on 11.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation
import UIKit

// MARK: note DTO
public struct Note: Equatable, CustomStringConvertible {
    
    // MARK: - Constants
    
    public static let defaultColor = UIColor(hex: "FFFFFFFF")!
    
    // MARK: - Properties
    
    public let uuid: String
    
    public var title: String
    public var content: String
    
    public var color: UIColor
    
    public var creationDate: Date
    public var erasureDate: Date?
    
    // MARK: - Initialization
    
    init(uuid: String = UUID().uuidString,
         title: String = "",
         content: String = "",
         color: UIColor = defaultColor,
         creationDate: Date = Date(),
         erasureDate: Date? = nil) {
        (self.uuid, self.title, self.content, self.color, self.creationDate, self.erasureDate) =
            (uuid, title, content, color, creationDate.withZeroNanoseconds, erasureDate?.withZeroNanoseconds)
    }
    
    public var isEmpty: Bool {
        return title == "" && content == "" && color == Note.defaultColor && erasureDate == nil
    }
    
    // MARK: - Equatable implementation
    
    public static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.uuid == rhs.uuid &&
            lhs.title == rhs.title &&
            lhs.content == rhs.content &&
            lhs.color == rhs.color &&
            lhs.creationDate == rhs.creationDate &&
            lhs.erasureDate == rhs.erasureDate
    }
    
    public static func != (lhs: Note, rhs: Note) -> Bool {
        return !(lhs == rhs)
    }
    
    // MARK: - CustomStringConvertible implementation
    
    public var description: String {
        return String(describing: json)
    }

}
