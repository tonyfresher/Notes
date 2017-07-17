//
//  Notebook.swift
//  Notes
//
//  Created by Anton Fresher on 11.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation
import CocoaLumberjack

public protocol NoteCollection : Sequence {
    
    var size: Int { get }
    
    subscript(index: Int) -> Note { get set }
    
    func add(note: Note)
    
    func update(note: Note)
    
    func remove(with uuid: String) throws -> Note
    
    func contains(with uuid: String) -> Bool
}

// MARK: Main class

public class Notebook : NoteCollection {
    
    fileprivate var notes: [Note]
    
    init(from notes: [Note] = []) {
        self.notes = notes
    }
    
    public var size: Int { return notes.count }
    
    public subscript(index: Int) -> Note {
        get {
            assert(index >= 0 && index < notes.count, "Index is out of bounds")
            return notes[index]
        }
        set { notes[index] = newValue }
    }
    
    public func makeIterator() -> NoteGenerator {
        return NoteGenerator(notes)
    }
    
    // MARK: Basic manipulations

    public func add(note: Note) {
        notes.append(note)
        DDLogInfo("\(note) added to \(self)")
    }
    
    public func update(note: Note) {
        for i in notes.indices {
            if notes[i].uuid == note.uuid {
                notes[i] = note
                DDLogInfo("\(notes[i]) updated to \(note)")
            }
        }
    }
    
    public func remove(with uuid: String) throws -> Note {
        for i in notes.indices {
            if notes[i].uuid == uuid {
                DDLogInfo("\(notes[i]) removed from \(self)")
                return notes.remove(at: i)
            }
        }
        
        DDLogError("Failed while finding note in notebook with such UUID: ")
        throw NotebookError.invalidUUID
    }
    
    public func contains(with uuid: String) -> Bool {
        return notes.contains { $0.uuid == uuid }
    }
}

// MARK: Helper class for sequencing support

public struct NoteGenerator: IteratorProtocol {
    let array: [Note]
    var currentIndex = 0
    
    init(_ array: [Note]) {
        self.array = array
    }
    
    mutating public func next() -> Note? {
        currentIndex += 1
        return currentIndex < array.count ? array[currentIndex] : nil
    }
}

// MARK: Import/export support

protocol FileStorageSupportable {
    
    func save(to filename: String) throws -> String
    
    static func load(from filename: String) -> Notebook?
}

extension Notebook : FileStorageSupportable {
    
    public func save(to filename: String) throws -> String {
        let filePath = getFilePath(filename: filename)
        
        if let path = filePath {
            do {
                let notesInJSON = notes.map { $0.json }
                try JSONSerialization
                    .data(withJSONObject: notesInJSON, options: .prettyPrinted)
                    .write(to: URL(fileURLWithPath: path))
            } catch {
                DDLogError(error.localizedDescription)
                throw error
            }
            
            DDLogInfo("\(self) saved to \(path)")
            return path
        } else {
            DDLogError("Filesystem error while saving")
            throw NotebookError.filesystemError
        }
    }
    
    public static func load(from filename: String) -> Notebook? {
        let filePath = getFilePath(filename: filename)
        
        if let path = filePath {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                
                var json: [[String: Any]]?
                json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]]
                
                guard json != nil else {
                    return nil
                }
                
                let notes = json!.map { Note.parse($0)! }
                
                DDLogInfo("\(notes) loaded from \(path)")
                return Notebook(from: notes)
            } catch {
                DDLogWarn("Failed while reading JSON from: \(path)\n\(error.localizedDescription)")
                return nil
            }
        }
        
        return nil
    }
}

fileprivate func getFilePath(filename: String) -> String? {
    guard let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true).first else {
        return nil
    }
    let path = "\(dir)/\(filename).plist"
    return path
}

// MARK: Additional handy protocols

extension Notebook: Equatable {
    public static func == (lhs: Notebook, rhs: Notebook) -> Bool {
        return lhs.notes == rhs.notes
    }
    
    public static func != (lhs: Notebook, rhs: Notebook) -> Bool {
        return !(lhs == rhs)
    }
    
}

extension Notebook: CustomStringConvertible {
    public var description: String {
        return String(describing: notes)
    }
}

// MARK: Custom error

enum NotebookError : Error {
    case filesystemError
    case invalidUUID
}
