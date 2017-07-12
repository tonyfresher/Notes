//
//  Note.swift
//  Notes
//
//  Created by Anton Fresher on 11.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation
import UIKit
//import UIColor_Hex_Swift


public struct Note {
    
    public static let defaultColor = UIColor(hexString: "#FFFFFF")!
    
    public let uuid: String
    
    public var title: String
    public var content: String
    public var color: UIColor
    public var erasureDate: Date?
    
    init(uuid: String = UUID().uuidString,
         title: String,
         content: String,
         color: UIColor = defaultColor,
         erasureDate: Date? = nil) {
        self.uuid = uuid
        self.title = title
        self.content = content
        self.color = color
        self.erasureDate = erasureDate?.withZeroNanoseconds
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
    
    static func parse(_ json: [String: Any]) -> Note?
}

extension Note: JSONConvertable {
    
    public var json: [String: Any] {
        var result: [String: Any] = [:]
        
        result["uuid"] = uuid
        result["title"] = title
        result["content"] = content
        if color != Note.defaultColor {
            result["color"] = color.hexString
        }
        if let date = erasureDate {
            result["erasureDate"] = date.iso8601String
        }
        
        return result
    }
    
    public static func parse(_ json: [String: Any]) -> Note? {
        let uuid = json["uuid"] as? String
        let title = json["title"] as? String
        let content = json["content"] as? String
        
        guard uuid != nil, title != nil, content != nil else {
            return nil
        }
        
        let colorString = json["color"] as? String
        let color : UIColor
        if colorString != nil {
            if let uiColor = UIColor(hexString: colorString!) {
                color = uiColor
            } else {
                return nil
            }
        } else {
            color = Note.defaultColor
        }
        
        let erasureDateString = json["erasureDate"] as? String
        if erasureDateString != nil {
            let erasureDate = Date(iso8601String: erasureDateString!)
            guard erasureDate != nil else {
                return nil
            }
            return Note(uuid: uuid!,
                        title: title!, content: content!,
                        color: color, erasureDate: erasureDate!)
        } else {
            return Note(uuid: uuid!,
                        title: title!, content: content!,
                        color: color, erasureDate: nil)
            
        }
    }
}

extension Note: CustomStringConvertible {
    
    public var description: String {
        return String(describing: json)
    }
}
