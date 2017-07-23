//
//  NotebookTests.swift
//  NotesTests
//
//  Created by Anton Fresher on 11.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import XCTest
@testable import Notes

class NotebookTests: XCTestCase {
    
    private var notebook = Notebook()
    
    override func setUp() {
        notebook = Variables.notebook
    }
    
    func testEquality() {
        let copy = Notebook(from: notebook.map { $0 })
        
        XCTAssertEqual(notebook.size, copy.size)
        for note in notebook { XCTAssertTrue(copy.contains(note)) }
    }
    
    func testSequencing() {
        XCTAssertEqual(notebook.size, 5)

        var index = 0
        for note in notebook {
            XCTAssertEqual(note, notebook[index])
            index += 1
        }
    }
    
    func testBasicManipulations() {
        var note = Note()
        
        // test "add"
        notebook.add(note: note)
        
        // test "contains"
        let contains = { (note: Note) -> Bool in
            self.notebook.contains(with: note.uuid)
        }
        XCTAssertTrue(contains(note))
        
        // test "update"
        note.title = "Foo"
        notebook.update(note: note)
        XCTAssertTrue(contains(note))
        XCTAssertEqual(notebook.first { $0.uuid == note.uuid }!.title, "Foo")
        
        // test "remove"
        let removed = try! notebook.remove(with: note.uuid)
        XCTAssertFalse(contains(note))
        XCTAssertEqual(note, removed)
    }
    
    func testSavingAndLoadingFromFile() {
        let filename = "notes"
        
        _ = try! notebook.save(to: filename)
        let loaded = Notebook.load(from: filename)
        XCTAssertEqual(loaded!, notebook)
    }

}
