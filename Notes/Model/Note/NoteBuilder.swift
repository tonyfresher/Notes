//
//  NoteBuilder.swift
//  Notes
//
//  Created by Anton Fresher on 26.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation
import UIKit

class NoteBuilder {
    
    var uuid: String?
    var title: String?
    var content: String?
    var color: UIColor?
    var creationDate: Date?
    var erasureDate: Date?
    
    init() {}
    
    init(from note: Note) {
        uuid = note.uuid
        title = note.title
        content = note.content
        color = note.color
        creationDate = note.creationDate
        erasureDate = note.erasureDate
    }
    
    func set(uuid: String) -> NoteBuilder {
        self.uuid = uuid
        return self
    }
    
    func set(title: String) -> NoteBuilder {
        self.title = title
        return self
    }
    
    func set(content: String) -> NoteBuilder {
        self.content = content
        return self
    }
    
    func set(color: UIColor) -> NoteBuilder {
        self.color = color
        return self
    }
    
    func set(creationDate: Date) -> NoteBuilder {
        self.creationDate = creationDate
        return self
    }
    
    func set(erasureDate: Date?) -> NoteBuilder {
        self.erasureDate = erasureDate
        return self
    }
    
    func build() -> Note? {
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
