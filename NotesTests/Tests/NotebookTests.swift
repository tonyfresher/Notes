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
        let note = Note()
        
        // test "add"
        notebook.add(note: note)
        
        XCTAssertTrue(notebook.contains(note))
        
        // test "update"
        let updated: Note! = NoteBuilder(from: note)
            .set(title: "Foo")
            .build()
        
        notebook.update(note: updated)
        XCTAssertTrue(notebook.contains(updated))
        XCTAssertEqual(notebook.first { $0.uuid == updated.uuid }!.title, "Foo")
        
        // test "remove"
        let removed = try! notebook.remove(with: note.uuid)
        XCTAssertFalse(notebook.contains(note))
        XCTAssertEqual(note, removed)
    }
    
    func testSavingAndLoadingFromFile() {
        let filename = "notes"
        
        _ = try! notebook.save(to: filename)
        let loaded = Notebook.load(from: filename)
        XCTAssertEqual(loaded!, notebook)
    }

}
