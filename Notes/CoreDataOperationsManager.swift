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
        return FetchOperation(notebook: notebook, context: managedObjectContext, success: success)
    }
    
    func add(_ note: Note, to notebook: Notebook) -> AsyncOperation<Void> {
        return AddOperation(note: note, notebook: notebook, context: managedObjectContext)
    }
    
    func update(_ note: Note) -> AsyncOperation<Void> {
        return UpdateOperation(note: note, context: managedObjectContext)
    }

    func remove(_ note: Note, from notebook: Notebook) -> AsyncOperation<Void> {
        return RemoveOperation(note: note, notebook: notebook, context: managedObjectContext)
    }

}
