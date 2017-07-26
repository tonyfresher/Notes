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
        guard let request = BackendRequests.getAll() else {
            cancel()
            return
        }
        let conversion: (Any) -> [Note]? = { json in
            // MARK: forming the array
            guard let response = json as? [[String: Any]] else {
                return nil
            }
            
            //MARK: parsing
            let notes = response.flatMap { Note.parse($0) }
        }
        
        let completionHandler = BackendRequests.completionHandler(of: "GET",
                                                                  result: conversion,
                                                                  in: self)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
        task.resume()
    }
    
}
