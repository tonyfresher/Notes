//
//  NoteEntity+CoreDataProperties.swift
//  Notes
//
//  Created by Anton Fresher on 19.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation
import CoreData


extension NoteEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteEntity> {
        return NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
    }

    @NSManaged public var uuid: String?
    
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    
    @NSManaged public var color: String?
    
    @NSManaged public var creationDate: NSDate?
    
    @NSManaged public var erasureDate: NSDate?
    
    @NSManaged public var notebook: NotebookEntity?
    
}
