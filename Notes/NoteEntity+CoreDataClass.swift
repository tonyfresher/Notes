//
//  NoteEntity+CoreDataClass.swift
//  Notes
//
//  Created by Anton Fresher on 19.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation
import UIKit
import CoreData

@objc(NoteEntity)
public class NoteEntity: NSManagedObject {
    
    convenience init(context moc: NSManagedObjectContext, from note: Note) {
        self.init(context: moc)
        
        (self.uuid, self.title, self.content, self.color, self.creationDate, self.erasureDate) =
            (note.uuid, note.title, note.content, note.color.hexString, note.creationDate as NSDate, note.erasureDate as NSDate?)
    }
    
    public func toNote() -> Note? {
        var json: [String: Any] = [:]
        
        json["uuid"] = uuid
        
        json["title"] = title
        json["content"] = content
        json["color"] = color
        
        json["creationDate"] = (creationDate as Date?)?.iso8601String
        json["erasureDate"] = (erasureDate as Date?)?.iso8601String
        
        return Note.parse(json)
    }
}
