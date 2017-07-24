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
        noteEntity.uuid = noteInfo.uuid
        noteEntity.title = noteInfo.title
        noteEntity.content = noteInfo.content
        noteEntity.color = noteInfo.color.hexString
        noteEntity.creationDate = noteInfo.creationDate as NSDate
        noteEntity.erasureDate = noteInfo.erasureDate as NSDate?
        return noteEntity
    }
    
    public func toNote() -> Note? {
        let json: [String: Any] = [
            "uuid": uuid as Any,
            
            "title": title as Any,
            "content": content as Any,
            "color": color as Any,
            
            "creationDate": (creationDate as Date?)?.iso8601String as Any,
            "erasureDate": (erasureDate as Date?)?.iso8601String as Any
        ]
        
        return Note.parse(json)
    }
    
}
