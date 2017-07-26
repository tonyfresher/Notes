//
//  PutOperation.swift
//  Notes
//
//  Created by Anton Fresher on 25.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation

class PutOperation: AsyncOperation<Notebook> {
    
    // PART: - Properties
    
    let notebook: Notebook
    
    let manager: CoreDataManager
    
    // PART: - Initialization
    
    init(notebook: Notebook, manager: CoreDataManager) {
        self.notebook = notebook
        self.manager = manager
    }
    
    // PART: - Work
    
    override func main() {
        
    }
    
}
