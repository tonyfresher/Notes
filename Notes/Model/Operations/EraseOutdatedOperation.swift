//
//  EraseOutdatedOperation.swift
//  Notes
//
//  Created by Anton Fresher on 24.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation
import CocoaLumberjack

class EraseOutdatedOperation: AsyncOperation<Notebook> {
    
    // PART: - Properties

    private let notebook: Notebook
    
    private let manager: CoreDataOperationsManager
    
    // PART: - Initialization
    
    init(notebook: Notebook, manager: CoreDataOperationsManager, success: Action? = nil) {
        self.notebook = notebook
        self.manager = manager
        
        super.init()
        
        self.success = success
    }
    
    // PART: - Work
    
    override func main() {
        let now = Date()
        
        for note in notebook {
            if let deadline = note.erasureDate, deadline <= now {
                guard let index = notebook.index(of: note) else { return }
                
                let erased = notebook.remove(at: index)
                
                let remove = manager.remove(erased, from: notebook)
                remove.success = { DDLogInfo("\(erased) was erased in \(now)") }
                
                Dispatcher.dispatch(coreData: remove)
            }
        }
        
        success?(notebook)
        finish()
    }
    
}
