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
public struct Note {
    
    // PART: - Constants
    
    public static let defaultColor: UIColor! = UIColor(hex: "#FFFFFFFF")
    
    // PART: - Properties
    
    public let uuid: String
    
    public let title: String
    public let content: String
    
    public let color: UIColor
    
    public let creationDate: Date
    public let erasureDate: Date?
    
    // PART: - Initialization
    
    init(uuid: String = UUID().uuidString,
         title: String = "",
         content: String = "",
         color: UIColor = defaultColor,
         creationDate: Date = Date(),
         erasureDate: Date? = nil) {
        (self.uuid, self.title, self.content, self.color, self.creationDate, self.erasureDate) =
            (uuid.lowercased(), title, content, color, creationDate, erasureDate)
    }
    
    public var isEmpty: Bool {
        return title == "" && content == "" && color == Note.defaultColor && erasureDate == nil
    }
    
    public func contentEquals(to note: Note) -> Bool {
        return uuid == note.uuid &&
            title == note.title &&
            content == note.content &&
            color == note.color &&
            Date.equalsWithoutNanoseconds(creationDate, note.creationDate) &&
            Date.equalsWithoutNanoseconds(erasureDate, note.erasureDate)
    }

}

extension Note: Equatable {
    
    public static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    public static func != (lhs: Note, rhs: Note) -> Bool {
        return !(lhs == rhs)
    }
    
}

extension Note: CustomStringConvertible {
    
    public var description: String {
        return String(describing: json)
    }
    
}
