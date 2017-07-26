//
//  NoteCollection.swift
//  Notes
//
//  Created by Anton Fresher on 21.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation

public protocol NoteCollection: Sequence {
    
    var size: Int { get }
    
    subscript(index: Int) -> Note { get set }
    
    func add(note: Note)
    
    func update(note: Note)
    
    func remove(with uuid: String) throws -> Note
    
    func remove(at index: Int) -> Note
    
    func contains(with uuid: String) -> Bool
    
}
