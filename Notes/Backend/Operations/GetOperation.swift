//
//  GetOperation.swift
//  Notes
//
//  Created by Anton Fresher on 25.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation

class GetOperation: AsyncOperation<Notebook> {
    
    // PART: - Properties
    
    let notebookUUID: String
    
    let manager: CoreDataManager
    
    // PART: - Initialization
    
    init(notebookUUID: String, manager: CoreDataManager) {
        self.notebookUUID = notebookUUID
        self.manager = manager
    }
    
    // PART: - Work
    
    override func main() {
        let request = BackendRequests.get
        
    }

}
