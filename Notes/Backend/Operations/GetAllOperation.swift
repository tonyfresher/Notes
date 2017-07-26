//
//  GetAllOperation.swift
//  Notes
//
//  Created by Anton Fresher on 26.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation
import CocoaLumberjack

class GetAllOperation: AsyncOperation<[Note]> {
    
    // PART: Initialization
    
    init(success: @escaping ([Note]) -> ()) {
        super.init()
        
        self.success = success
    }
    
    // PART: - Work
    
    override func main() {
        let conversion: (Any) -> [Note]? = { json in
            // TODO: implement
            
            // MARK: forming the array
            guard let response = json as? [[String: Any]] else {
                return nil
            }
            
            //MARK: parsing
            let notes = response.flatMap { Note.parse($0) }
        }
        
        BackendRequests.performDataTask(method: "GET(all)",
                                        request: BackendRequests.getAll(),
                                        using: conversion,
                                        in: self)
    }
    
}
