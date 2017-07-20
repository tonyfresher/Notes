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
        let byDateSortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        
        guard let notesSet = notes else {
            return nil
        }
        
        let noteEntities = notesSet.sortedArray(using: [byDateSortDescriptor]) as! [NoteEntity]
        let notesArray = noteEntities.map { $0.toNote()! }
        
        return Notebook(from: notesArray)
    }
    
}
