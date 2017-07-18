//
//  Notebook+FileStorageSupport.swift
//  Notes
//
//  Created by Anton Fresher on 18.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation
import CocoaLumberjack

// MARK: Import/export support

protocol FileStorageSupport {
    
    func save(to filename: String) throws -> String
    
    static func load(from filename: String) -> Notebook?
}

extension Notebook: FileStorageSupport {
    
    public func save(to filename: String) throws -> String {
        let filePath = getFilePath(filename: filename)
        
        if let path = filePath {
            do {
                let notesInJSON = self.map { $0.json }
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
            throw NotebookError.noSuitablePath
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
