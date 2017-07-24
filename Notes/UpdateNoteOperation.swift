//
//  UpdateNoteOperation.swift
//  Notes
//
//  Created by Anton Fresher on 24.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation
import CoreData
import CocoaLumberjack

class UpdateNoteOperation: AsyncOperation {
    
    // PART: - Properties
    
    let note: Note
    
    let context: NSManagedObjectContext
    
    // PART: - Initialization
    
    init(note: Note, context: NSManagedObjectContext) {
        self.note = note
        self.context = context
    }
    
    // PART: - Work
    
    override func main() {
        context.perform { [weak self] in
            guard let sself = self else { return }
            
            do {
                _ = try NoteEntity.findOrCreateNoteEntity(matching: sself.note, in: sself.context)
                
                try sself.context.save()
            } catch {
                DDLogError("Error while updating \(sself.note): \(error.localizedDescription)")
                sself.cancel()
            }
            
            sself.finish()
        }
    }
    
}
