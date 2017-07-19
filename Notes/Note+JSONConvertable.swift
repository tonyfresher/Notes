//
//  Note+JSONConvertable.swift
//  Notes
//
//  Created by Anton Fresher on 18.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation
import UIKit

// MARK: JSON conversion support for Note

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
        
        result["creationDate"] = creationDate.iso8601String
        
        if let date = erasureDate {
            result["erasureDate"] = date.iso8601String
        }
        
        return result
    }
    
    public static func parse(_ json: [String: Any]) -> Note? {
        let uuidOptional = json["uuid"] as? String
        let titleOptional = json["title"] as? String
        let contentOptional = json["content"] as? String
        let creationDateStringOptional = json["creationDate"] as? String
        
        guard let uuid = uuidOptional,
            let title = titleOptional,
            let content = contentOptional,
            let creationDateString = creationDateStringOptional,
            let creationDate = Date(iso8601String: creationDateString) else {
                return nil
        }
        
        let colorString = json["color"] as? String
        let color : UIColor
        if let string = colorString {
            if let uiColor = UIColor(hex: string) {
                color = uiColor
            } else {
                return nil
            }
        } else {
            color = Note.defaultColor
        }
        
        let erasureDateStringOptional = json["erasureDate"] as? String
        if let erasureDateString = erasureDateStringOptional {
            guard let erasureDate = Date(iso8601String: erasureDateString) else {
                return nil
            }
            return Note(uuid: uuid,
                        title: title, content: content, color: color,
                        creationDate: creationDate, erasureDate: erasureDate)
        } else {
            return Note(uuid: uuid,
                        title: title, content: content, color: color,
                        creationDate: creationDate, erasureDate: nil)
            
        }
    }
}
