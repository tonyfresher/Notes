//
//  Notebook+FileStorageSupport.swift
//  Notes
//
//  Created by Anton Fresher on 18.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation
import CocoaLumberjack

// MARK: file as a storage usage support
protocol FileStorageSupport {
    
    func save(to filename: String) throws -> String
    
    static func load(from filename: String) -> Notebook?

}

extension Notebook: FileStorageSupport {
    
    public func save(to filename: String) throws -> String {
        let filePath = getFilePath(filename: filename)
        
        if let path = filePath {
            do {
                let notesJSON = self.map { $0.json }
                let notebookJSON: [String : Any]  = [
                    "uid": uuid,
                    "creationDate": creationDate.timeIntervalSince1970,
                    "notes": notesJSON
                ]
                try JSONSerialization
                    .data(withJSONObject: notebookJSON, options: .prettyPrinted)
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
                
                guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let uuid = json["uid"] as? String,
                    let creationDateTimeInterval = json["creationDate"] as? TimeInterval,
                    let notesArray = json["notes"] as? [[String: Any]] else {
                    return nil
                }
                
                let creationDate = Date(timeIntervalSince1970: creationDateTimeInterval)
                
                let notes = notesArray.map { Note.parse($0)! }
                
                DDLogInfo("\(notes) loaded from \(path)")
                return Notebook(uuid: uuid, creationDate: creationDate, from: notes)
            } catch {
                DDLogWarn("Failed while reading JSON from: \(path)\n\(error.localizedDescription)")
                return nil
            }
        }
        
        return nil
    }

}

/// - Parameter filename: name of the file in document directory
/// - Returns: path to this file
fileprivate func getFilePath(filename: String) -> String? {
    guard let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true).first else {
        return nil
    }
    let path = "\(dir)/\(filename).plist"
    return path
}
