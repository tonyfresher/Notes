//
//  Notebook.swift
//  Notes
//
//  Created by Anton Fresher on 11.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation
import CocoaLumberjack


public protocol NoteCollection {
    
    var notes: [Note] { get }
    
    func addNote(_ note: Note)
    
    func removeNote(uuid: String) -> Note
    
    func saveToFile(_ filename: String) throws -> String
    
    static func loadFromFile(_ filename: String) -> Notebook?
}

public class Notebook : NoteCollection {
    
    public private(set) var notes: [Note] = []
    
    init(from notes: [Note]) {
        self.notes = notes
    }
    
    public func addNote(_ note: Note) {
        notes.append(note)
        
        debugPrint("\(note) added to \(self)")
    }
    
    public func removeNote(uuid: String) -> Note {
        for i in notes.indices {
            if notes[i].uuid == uuid {
                debugPrint("\(notes[i]) removed from \(self)")
                return notes.remove(at: i)
            }
        }
        
        fatalError("There is no note in notebook with such UUID")
    }
    
    public func saveToFile(_ filename: String) throws -> String {
        let filePath = getFilePath(filename: filename)
        
        if let path = filePath {
            do {
                let notesInJSON = notes.map { $0.json }
                try JSONSerialization
                    .data(withJSONObject: notesInJSON, options: .prettyPrinted)
                    .write(to: URL(fileURLWithPath: path))
            } catch {
                debugPrint(error.localizedDescription)
            }
            
            debugPrint("\(self) saved to \(path)")
            return path
        } else {
            debugPrint("filesystem error while saving")
            throw FileError()
        }
    }
    
    public static func loadFromFile(_ filename: String) -> Notebook? {
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
                return Notebook(from: notes)
            } catch {
                debugPrint("failed while reading JSON from: \(path)\n" + error.localizedDescription)
            }
        }
        
        return nil
    }
}

extension Notebook: CustomStringConvertible {
    public var description: String {
        return String(describing: notes)
    }
}

struct FileError : Error {}

fileprivate func getFilePath(filename: String) -> String? {
    guard let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true).first else {
        return nil
    }
    let path = "\(dir)/\(filename).plist"
    return path
}
