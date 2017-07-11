//
//  Note.swift
//  Notes
//
//  Created by Anton Fresher on 11.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation
import UIKit


public struct Note {
    
    public let uuid: String
    
    public var title: String
    public var content: String
    public var color: UIColor
    public var erasureDate: Date?
    
    init(uuid: String = UUID().uuidString,
         title: String,
         content: String,
         color: UIColor = UIColor.white,
         erasureDate: Date? = nil) {
        self.uuid = uuid
        self.title = title
        self.content = content
        self.color = color
        self.erasureDate = erasureDate
    }
}

extension Note: Equatable {
    
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
}

public protocol JSONConvertable {
    
    var json: [String: Any] { get }
    
    static func parse(_ json: [String: Any]) -> Note
}

extension Note: JSONConvertable {
    
    public var json: [String: Any] {
        var result: [String: Any] = [:]
        
        result["uuid"] = uuid
        result["title"] = title
        result["content"] = content
        if color != UIColor.white {
            result["color"] = color
        }
        if let date = erasureDate {
            result["erasureDate"] = date
        }
        
        return result
    }
    
    public static func parse(_ json: [String: Any]) -> Note {
        let uuid = json["uuid"] as? String
        let title = json["title"] as? String
        let content = json["content"] as? String
        
        guard uuid != nil, title != nil, content != nil else {
            fatalError("Wrong JSON structure")
        }
        
        let color = json["color"] as? UIColor ?? UIColor.white
        let erasureDate = json["erasureDate"] as? Date
        
        return Note(uuid: uuid!,
                    title: title!,
                    content: content!,
                    color: color,
                    erasureDate: erasureDate)
    }
}

extension Note: CustomStringConvertible {
    
    public var description: String {
        return String(describing: json)
    }
}
