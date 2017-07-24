//
//  AddNoteToNotebookOperation.swift
//  Notes
//
//  Created by Anton Fresher on 24.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation
import CoreData
import CocoaLumberjack

class AddNoteToNotebookOperation: AsyncOperation {
    
    let note: Note
    
    let notebook: Notebook
    
    let context: NSManagedObjectContext
    
    init(note: Note, notebook: Notebook, context: NSManagedObjectContext) {
        self.note = note
        self.notebook = notebook
        self.context = context
    }
    
    override func main() {
        context.perform { [weak self] in
            guard let sself = self else { return }
            
            do {
                let notebookEntity = try NotebookEntity.findOrCreateNotebookEntity(matching: sself.notebook, in: sself.context)
                let noteEntity = try NoteEntity.findOrCreateNoteEntity(matching: sself.note, in: sself.context)
            
                notebookEntity.addToNotes(noteEntity)
                
                try sself.context.save()
            } catch {
                DDLogError("Error while saving \(sself.note): \(error.localizedDescription)")
                sself.cancel()
            }
            
            sself.finish()
        }
    }
    
}
