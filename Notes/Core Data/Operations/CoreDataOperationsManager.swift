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
    
    func add(_ note: Note, to notebook: Notebook) -> AsyncOperation<Void> {
        return AddToNotebookOperation(note: note, notebook: notebook, context: managedObjectContext)
    }
    
    func createOrUpdate(_ note: Note) -> AsyncOperation<Void> {
        return CreateOrUpdateNoteOperation(note: note, context: managedObjectContext)
    }

    func remove(_ note: Note, from notebook: Notebook) -> AsyncOperation<Void> {
        return RemoveFromNotebookOperation(note: note, notebook: notebook, context: managedObjectContext)
    }

    func contains(_ note: Note, in notebookUUID: String, success: @escaping (Bool) -> ()) -> AsyncOperation<Bool> {
        return ContainsNoteOperation(note: note, notebookUUID: notebookUUID, context: managedObjectContext, success: success)
    }

}
