//
//  GetOperation.swift
//  Notes
//
//  Created by Anton Fresher on 25.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation

class GetOperation: AsyncOperation<Note> {
    
    // PART: - Properties
    
    let noteUUID: String
    
    // PART: - Initialization
    
    init(noteUUID: String, manager: CoreDataManager, success: @escaping (Note) -> ()) {
        self.noteUUID = noteUUID
        
        super.init()
        
        self.success = success
    }
    
    // PART: - Work
    
    override func main() {
        let conversion: (Any) -> Note? = { json in
            // TODO: implement
        }
        
        BackendRequests.performDataTask(method: "GET",
                                        request: BackendRequests.get(with: noteUUID),
                                        using: conversion,
                                        in: self)
    }

}
