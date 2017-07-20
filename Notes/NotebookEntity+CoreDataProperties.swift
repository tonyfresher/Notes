//
//  NotebookEntity+CoreDataProperties.swift
//  Notes
//
//  Created by Anton Fresher on 19.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation
import CoreData


extension NotebookEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NotebookEntity> {
        return NSFetchRequest<NotebookEntity>(entityName: "NotebookEntity")
    }

    @NSManaged public var uuid: String?
    
    @NSManaged public var notes: NSSet?
    
}

// MARK: Generated accessors for notes
extension NotebookEntity {

    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: NoteEntity)

    @objc(removeNotesObject:)
    @NSManaged public func removeFromNotes(_ value: NoteEntity)

    @objc(addNotes:)
    @NSManaged public func addToNotes(_ values: NSSet)

    @objc(removeNotes:)
    @NSManaged public func removeFromNotes(_ values: NSSet)

}
