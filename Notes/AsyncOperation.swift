//
//  AsyncOperation.swift
//  Notes
//
//  Created by Anton Fresher on 23.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import Foundation

class AsyncOperation : Operation {
    
    typealias Action = (() -> ())
    
    var success: Action?
    
    // PART: - Flags
    
    private var _executing = false
    private var _finished = false
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override var isExecuting: Bool {
        return _executing
    }
    
    override var isFinished: Bool {
        return _finished
    }
    
    // PART: - Action
    
    override func start() {
        guard !isCancelled else {
            finish()
            return
        }
        
        willChangeValue(forKey: "isExecuting")
        _executing = true
        main() // QUESTION: whybefore didChangeValue?
        didChangeValue(forKey: "isExecuting")
    }
    
    override func main() {
        // MARK: should be overriden
        finish()
    }
    
    func finish() {
        success?()
        
        willChangeValue(forKey: "isFinished")
        _finished = true
        didChangeValue(forKey: "isFinished")
    }
}
