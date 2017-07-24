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
    
    // PART: - Properties

    private let coreDataManager: CoreDataManager
    
    private let managedObjectContext: NSManagedObjectContext
    
    // PART: - Initialization

    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        self.managedObjectContext = coreDataManager.createChildManagedObjectContext()
    }

    // PART: - Operations

    func fetch(notebook: Notebook, success: @escaping (Notebook) -> ()) -> AsyncOperation<Notebook> {
        return FetchNotebookOperation(notebook: notebook, context: managedObjectContext, success: success)
    }
    
    func eraseOutdatedNotes(in notebook: Notebook, success: @escaping (Notebook) -> ()) -> AsyncOperation<Notebook> {
        return EraseOutdatedNotesOperation(notebook: notebook, manager: self, success: success)
    }
    
    func add(_ note: Note, to notebook: Notebook) -> AsyncOperation<Void> {
        let operation = AddNoteOperation(note: note, notebook: notebook, context: managedObjectContext)
        operation.success = { [weak self] in
            self?.coreDataManager.saveChanges()
        }
        return operation
    }
    
    func remove(_ note: Note, from notebook: Notebook) -> AsyncOperation<Void> {
        let operation = RemoveNoteOperation(note: note, notebook: notebook, context: managedObjectContext)
        operation.success = { [weak self] in
            self?.coreDataManager.saveChanges()
        }
        return operation
    }
    
    func update(_ note: Note) -> AsyncOperation<Void> {
        let operation = UpdateNoteOperation(note: note, context: managedObjectContext)
        operation.success = { [weak self] in
            self?.coreDataManager.saveChanges()
        }
        return operation
    }
    
}
