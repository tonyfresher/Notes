//
//  NoteComponents.swift
//  Notes
//
//  Created by Anton Fresher on 26.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation
import UIKit

class NoteComponents {
    
    // PART: - Properties
    
    var uuid: String?
    var title: String?
    var content: String?
    var color: UIColor?
    var creationDate: Date?
    var erasureDate: Date?
    
    // PART: - Initialization
    
    init() {}
    
    init(from note: Note) {
        uuid = note.uuid
        title = note.title
        content = note.content
        color = note.color
        creationDate = note.creationDate
        erasureDate = note.erasureDate
    }
    
    // PART: - Build
    
    var note: Note? {
        guard let uuidUnwrapped = uuid,
            let titleUnwrapped = title,
            let contentUnwrapped = content,
            let colorUnwrapped = color,
            let creationDateUnwrapped = creationDate else {
                return nil
        }
        
        return Note(uuid: uuidUnwrapped,
                    title: titleUnwrapped, content: contentUnwrapped, color: colorUnwrapped,
                    creationDate: creationDateUnwrapped, erasureDate: erasureDate)
    }
    
}
