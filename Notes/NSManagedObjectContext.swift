//
//  NSManagedObjectContext.swift
//  Notes
//
//  Created by Anton Fresher on 26.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    func save(recursively: Bool) throws {
        var _error: Error!
        
        performAndWait {
            if self.hasChanges {
                do {
                    try self.saveThisAndParentContext(recursively)
                } catch {
                    _error = error
                }
            }
        }
        
        if let error = _error {
            throw error
        }
    }
    
    func saveThisAndParentContext(_ recursively: Bool) throws {
        try save()
        
        if recursively {
            if let parent = parent {
                try parent.save(recursively: recursively)
            }
        }
    }
    
}
