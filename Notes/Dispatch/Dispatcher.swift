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

    private static let backgroundQueue = OperationQueue()

    private static let coreDataQueue = OperationQueue(maxConcurrentOperationCount: 1)

    private static let backendQueue = OperationQueue(maxConcurrentOperationCount: 1)

    // PART: - Dispatch

    static func dispatch(main op: Operation) {
        mainQueue.addOperation(op)
    }

    static func dispatch(background op: Operation) {
        backgroundQueue.addOperation(op)
    }

    static func dispatch(coreData op: Operation) {
        coreDataQueue.addOperation(op)
    }

    static func dispatch(backend op: Operation) {
        backendQueue.addOperation(op)
    }

}

extension OperationQueue {
    
    // MARK: for the ability to pass maximum count of concurrent operations during initialization
    convenience init(maxConcurrentOperationCount: Int) {
        self.init()
        self.maxConcurrentOperationCount = maxConcurrentOperationCount
    }
    
}
