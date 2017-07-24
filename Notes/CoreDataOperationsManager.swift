//
//  CoreDataOperationsManager.swift
//  Notes
//
//  Created by Anton Fresher on 24.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation
import CoreData

class CoreDataOperationsManager {
    
    private let coreDataManager: CoreDataManager
    private let managedObjectContext: NSManagedObjectContext
    
    private let queue: OperationQueue
    
    init(coreDataManager: CoreDataManager, queue: OperationQueue) {
        self.coreDataManager = coreDataManager
        self.managedObjectContext = coreDataManager.createChildManagedObjectContext()
        
        self.queue = queue
    }
    
    func addNoteToNotebookOperation(note: Note, notebook: Notebook) -> Operation {
        let operation = AddNoteToNotebookOperation(note: note, notebook: notebook, context: managedObjectContext)
        operation.success = { [weak self] in
            self?.coreDataManager.saveChanges()
        }
        return operation
    }
    
    func removeNoteFromNotebook(note: Note, notebook: Notebook) -> Operation {
        let operation = RemoveNoteToNotebookOperation(note: note, notebook: notebook, context: managedObjectContext)
        operation.success = { [weak self] in
            self?.coreDataManager.saveChanges()
        }
        return operation
    }
    
    func updateNoteOperation(note: Note, notebook: Notebook) -> Operation {
        let operation = UpdateNoteOperation(note: note, context: managedObjectContext)
        operation.success = { [weak self] in
            self?.coreDataManager.saveChanges()
        }
        return operation
    }
    
}
