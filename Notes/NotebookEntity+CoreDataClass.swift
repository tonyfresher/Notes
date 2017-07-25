//
//  NotebookEntity+CoreDataClass.swift
//  Notes
//
//  Created by Anton Fresher on 19.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation
import CoreData
import CocoaLumberjack

@objc(NotebookEntity)
public class NotebookEntity: NSManagedObject {

    /// Finds notebook with certain UUID and updates its attributes or creates new note matching notebookInfo in NSManagedContext
    ///
    /// - Parameters:
    ///   - notebookInfo: Notebook template for NotebookEntity
    ///   - context: NSManagedContext for manipulations
    /// - Returns: updated or created NotebookEntity
    /// - Throws: if context is unable to fetch request for NotebookEntity
    static func findOrCreateNotebookEntity(matching notebookInfo: Notebook, in context: NSManagedObjectContext) throws -> NotebookEntity {
        let request: NSFetchRequest<NotebookEntity> = NotebookEntity.fetchRequest()
        request.predicate = NSPredicate(format: "uuid = %@", notebookInfo.uuid)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "NotebookEntity.findOrCreateNotebookEntity -- database inconsistency")
                return matches[0]
            }
        } catch {
            DDLogError("While fetching NotebookEntity the error occured")
            throw error
        }
        
        let notebookEntity = NotebookEntity(context: context)
        notebookEntity.uuid = notebookInfo.uuid
        notebookEntity.creationDate = notebookInfo.creationDate as NSDate
        do {
            let noteEntities = try notebookInfo.map { (noteInfo) -> NoteEntity in
                do {
                    return try NoteEntity.findOrCreateNoteEntity(matching: noteInfo, in: context)
                } catch { throw error }
            }
            
            notebookEntity.notes = Set(noteEntities) as NSSet
            return notebookEntity
        } catch {
            DDLogError("While searching for NoteEntity the error occured")
            throw error
        }
    }
    
    public func toNotebook() -> Notebook? {
        guard let notesUnboxed = self.notes,
            let uuidUnboxed = self.uuid,
            let creationDateUnboxed = creationDate else {
                return nil
        }
        
        let sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let noteEntities = notesUnboxed.sortedArray(using: sortDescriptors) as! [NoteEntity]
        let notesArray = noteEntities.map { $0.toNote()! }
        
        return Notebook(uuid: uuidUnboxed, creationDate: creationDateUnboxed as Date, from: notesArray)
    }
    
}
