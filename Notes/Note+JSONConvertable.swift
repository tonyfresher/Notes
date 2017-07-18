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
