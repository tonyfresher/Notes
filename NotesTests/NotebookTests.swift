//
//  NotebookTests.swift
//  NotesTests
//
//  Created by Anton Fresher on 11.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import XCTest
import UIColor_Hex_Swift
@testable import Notes

class NotebookTests: XCTestCase {
    
    private var notebook = Notebook(from: [
        Note(title: "Foo0", content: "Bar"),
        Note(title: "Foo1", content: "Bar", color: Note.defaultColor),
        Note(title: "Foo2", content: "Bar", color: UIColor("#000000")),
        Note(title: "Foo3", content: "Bar", erasureDate: Date()),
        Note(title: "Foo4", content: "Bar", color: UIColor("#000000"), erasureDate: Date())
        ])
    
    func testSaveAndLoad() {
        let filename = "notes"
        
        let path = try? notebook.saveToFile(filename)
        if path != nil {
            let loaded = Notebook.loadFromFile(filename)
            XCTAssertEqual(loaded!.notes, notebook.notes)
        } else {
            XCTFail()
        }
    }
}
