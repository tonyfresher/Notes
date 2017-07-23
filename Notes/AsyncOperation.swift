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
    
    var work: Action
    
    var success: Action?
    
    override var isAsynchronous: Bool {
        return true
    }
    
    private var _executing = false
    
    override var isExecuting: Bool {
        return _executing
    }
    
    private var _finished = false
    
    override var isFinished: Bool {
        return _finished
    }
    
    init(do work: @escaping Action, success: Action? = nil) {
        self.work = work
        self.success = success
    }
    
    override func start() {
        guard !isCancelled else {
            finish()
            return
        }
        
        willChangeValue(forKey: "isExecuting")
        _executing = true
        main()
        didChangeValue(forKey: "isExecuting")
    }
    
    override func main() {
        work()
        finish()
    }
    
    private func finish() {
        success?()
        
        willChangeValue(forKey: "isFinished")
        _finished = true
        didChangeValue(forKey: "isFinished")
    }
}
