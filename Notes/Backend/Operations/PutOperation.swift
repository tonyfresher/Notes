//
//  PutOperation.swift
//  Notes
//
//  Created by Anton Fresher on 25.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation

class PutOperation: AsyncOperation<Note> {
    
    // PART: - Properties
    
    let note: Note
    
    // PART: - Initialization
    
    init(note: Note) {
        self.note = note
    }
    
    // PART: - Work
    
    override func main() {        
        let conversion: (Any) -> Note? = { json in
            // MARK: converting to the required fomat
            guard let response = json as? [String: Any] else {
                return nil
            }
            
            //MARK: parsing
            let note = Note.parse(response)            
            return note
        }
        
        BackendRequests.performDataTask(method: "PUT",
                                        request: BackendRequests.put(note),
                                        using: conversion,
                                        in: self)
    }
    
}
