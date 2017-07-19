//
//  NotebookEntity+CoreDataClass.swift
//  Notes
//
//  Created by Anton Fresher on 19.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation
import CoreData

@objc(NotebookEntity)
public class NotebookEntity: NSManagedObject {

    convenience init(context moc: NSManagedObjectContext, from notebook: Notebook) {
        self.init(context: moc)
        
        self.notes = Set(notebook.map { NoteEntity(context: moc, from: $0) }) as NSSet
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
