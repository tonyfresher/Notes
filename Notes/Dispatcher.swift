//
//  Dispatcher.swift
//  Notes
//
//  Created by Anton Fresher on 24.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation

class Dispatcher {
    
    // PART: - Queues
    
    private static let mainQueue = OperationQueue.main
    
    private static let coreDataQueue = OperationQueue(maxConcurrentOperationCount: 1)
    
    // PART: - Dispatching

    static func dispatchToMain(_ op: Operation) {
        mainQueue.addOperation(op)
    }
    
    static func dispatchToCoreData(_ op: Operation) {
        coreDataQueue.addOperation(op)
    }
    
}

// MARK: for the ability to pass maximum count of concurrent operations during initialization
extension OperationQueue {
    
    convenience init(maxConcurrentOperationCount: Int) {
        self.init()
        self.maxConcurrentOperationCount = maxConcurrentOperationCount
    }
    
}
