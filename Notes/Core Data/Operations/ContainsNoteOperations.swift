//
//  ContainsNoteOperations.swift
//  Notes
//
//  Created by Anton Fresher on 26.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation
import CoreData
import CocoaLumberjack

class ContainsNoteOperation: AsyncOperation<Bool> {
    
    // PART: - Properties
    
    let note: Note
    
    let notebookUUID: String
    
    let context: NSManagedObjectContext
    
    // PART: - Initialization
    
    init(note: Note, notebookUUID: String, context: NSManagedObjectContext, success: @escaping (Bool) -> ()) {
        self.note = note
        self.notebookUUID = notebookUUID
        self.context = context
        
        super.init()

        self.success = success
    }
    
    // PART: - Work
    
    override func main() {
        context.perform { [weak self] in
            guard let sself = self else { return }
            
            do {
                let noteEntity = try NoteEntity.findOrCreateNoteEntity(matching: sself.note, in: sself.context)
                
                var noteContainsInNotebook = false
                
                if let notebookEntity = noteEntity.notebook,
                    notebookEntity.uuid == sself.notebookUUID {
                    noteContainsInNotebook = true
                }
                
                sself.success?(noteContainsInNotebook)
            } catch {
                DDLogError("Error while checking if Note(uuid: \(sself.note.uuid)) contains in Notebook(uuid: \(sself.notebookUUID)): \(error.localizedDescription)")
                sself.cancel()
            }
            
            sself.finish()
        }
    }
    
}
