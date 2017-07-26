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
import CocoaLumberjack

@objc(NoteEntity)
public class NoteEntity: NSManagedObject {
    
    /// Finds note with certain UUID and updates its attributes or creates new note matching noteInfo in NSManagedContext
    ///
    /// - Parameters:
    ///   - noteInfo: Note template for NoteEntity
    ///   - context: NSManagedContext for manipulations
    /// - Returns: updated or created NoteEntity
    /// - Throws: if context is unable to fetch request for NoteEntity
    static func findOrCreateNoteEntity(matching noteInfo: Note, in context: NSManagedObjectContext) throws -> NoteEntity {
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "uuid = %@", noteInfo.uuid)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "NoteEntity.findOrCreateNoteEntity -- database inconsistency")
                return matches[0]
            }
        } catch {
            DDLogError("While fetching NoteEntity the error occured")
            throw error
        }
        
        let noteEntity = NoteEntity(context: context)
        noteEntity.update(from: noteInfo)
        
        return noteEntity
    }
    
    func update(from noteInfo: Note) {
        self.uuid = noteInfo.uuid
        self.title = noteInfo.title
        self.content = noteInfo.content
        self.color = noteInfo.color.hexString
        self.creationDate = noteInfo.creationDate as NSDate
        self.erasureDate = noteInfo.erasureDate as NSDate?
    }
    
    func toNote() -> Note? {
        let json: [String: Any] = [
            "uid": uuid as Any,
            
            "title": title as Any,
            "content": content as Any,
            "color": color as Any,
            
            "creation_date": (creationDate as Date?)?.timeIntervalSince1970 as Any,
            "destroy_date": (erasureDate as Date?)?.timeIntervalSince1970 as Any
        ]
        
        return Note.parse(json)
    }
    
}
