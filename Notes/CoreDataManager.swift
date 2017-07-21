//
//  CoreDataManager.swift
//  Notes
//
//  Created by Anton Fresher on 18.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation
import CoreData
import CocoaLumberjack

public class CoreDataManager {
    
    typealias CoreDataManagerCompletion = () -> ()
    
    // MARK: - Properties
    
    private let modelName: String
    
    private let completion: CoreDataManagerCompletion?
    
    // MARK: - Core Data Stack
    
    private lazy var privateManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = { NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel) }()
    
    private var persistentStoreURL: URL {
        let storeName = "\(modelName).sqlite"
        let fileManager = FileManager.default
        
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        return documentsDirectoryURL.appendingPathComponent(storeName)
    }
    
    // MARK: - Initialization
    
    init(modelName: String, completion: CoreDataManagerCompletion? = nil) {
        self.modelName = modelName
        self.completion = completion
        
        setup()
    }
    
    // MARK: Supporting initialization methods
    
    private func setup() {
        _ = privateManagedObjectContext.persistentStoreCoordinator
        
        DispatchQueue.global().async {
            self.addPersistentStore()
            
            DispatchQueue.main.async { self.completion?() }
        }
    }
    
    private func addPersistentStore() {
        let persistentStoreURL = self.persistentStoreURL
        let options = [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true
        ]
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: options)
        } catch {
            fatalError("Unable to Load Persistent Store")
        }
    }
    
    /// - Returns: a new private child context
    public func createChildManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.parent = privateManagedObjectContext
        
        return managedObjectContext
    }
    
    /// Saves changes in private context
    public func saveChanges() {        
        privateManagedObjectContext.perform {
            do {
                if self.privateManagedObjectContext.hasChanges {
                    try self.privateManagedObjectContext.save()
                }
            } catch {
                DDLogError("Unable to save changes of private managed object context\n\(error), \(error.localizedDescription)")
            }
        }
    }
    
}
