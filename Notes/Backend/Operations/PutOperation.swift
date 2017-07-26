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
            // TODO: implement
        }
        
        BackendRequests.performDataTask(method: "PUT",
                                        request: BackendRequests.put(note),
                                        using: conversion,
                                        in: self)
    }
    
}
