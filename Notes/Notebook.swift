//
//  Notebook.swift
//  Notes
//
//  Created by Anton Fresher on 11.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation
import CocoaLumberjack

// MARK: Notebook DTO
public class Notebook: NoteCollection, Equatable, CustomStringConvertible {
    
    // MARK: - Properties
    
    public let uuid: String
    public var creationDate: Date
    
    private var notes: [Note]
    
    public var size: Int { return notes.count }
    
    // MARK: - Initialization
    
    init(uuid: String = UUID().uuidString,
         creationDate: Date = Date(),
         from notes: [Note] = []) {
        self.uuid = uuid
        self.creationDate = creationDate
        self.notes = notes
    }
    
    // MARK: Access control
    
    public subscript(index: Int) -> Note {
        get {
            assert(index >= 0 && index < notes.count, "Notebook.subscript -- index is out of bounds")
            return notes[index]
        }
        set { notes[index] = newValue }
    }
    
    public func makeIterator() -> NoteIterator {
        return NoteIterator(notes)
    }
    
    // MARK: Basic manipulations

    public func add(note: Note) {
        notes.append(note)
        DDLogInfo("\(note) was added to \(self)")
    }
    
    public func update(note: Note) {
        for i in notes.indices {
            if notes[i].uuid == note.uuid {
                let previousVersion = notes[i]
                notes[i] = note
                DDLogInfo("\(previousVersion) was updated to \(note)")
            }
        }
    }
    
    public func remove(with noteUUID: String) throws -> Note {
        for i in notes.indices {
            if notes[i].uuid == noteUUID {
                let removed = notes.remove(at: i)
                DDLogInfo("\(removed) was removed from \(self)")
                return removed
            }
        }
        
        DDLogError("Failed while finding note in notebook with such UUID: ")
        throw NotebookError.invalidUUID
    }
    
    public func remove(at index: Int) -> Note {
        return notes.remove(at: index)
    }
    
    public func contains(with noteUUID: String) -> Bool {
        return notes.contains { $0.uuid == noteUUID }
    }
    
    // MARK: Equatable support
    
    public static func == (lhs: Notebook, rhs: Notebook) -> Bool {
        return lhs.uuid == rhs.uuid && lhs.notes == rhs.notes
    }
    
    public static func != (lhs: Notebook, rhs: Notebook) -> Bool {
        return !(lhs == rhs)
    }

    // MARK: CustomStringConvertible support
    
    public var description: String {
        return String(describing: notes)
    }

    // MARK: Generator struct for sequencing support
    
    public struct NoteIterator: IteratorProtocol {
        let array: [Note]
        var index = 0
        
        init(_ array: [Note]) {
            self.array = array
        }
        
        public mutating func next() -> Note? {
            let nextElement = index < array.count ? array[index] : nil
            index += 1
            return nextElement
        }
    }

}
