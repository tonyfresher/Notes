//
//  NotesTests.swift
//  NotesTests
//
//  Created by Anton Fresher on 11.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import XCTest
@testable import Notes

class NotesTests: XCTestCase {
    
    private var notes: [Note] = []
    
    override func setUp() {
        notes = Variables.notes
    }
    
    func testEquality() {
        let copies = notes.map { $0 }
        XCTAssertEqual(notes, copies)
    }
    
    func testJSON() {
        var jsons: [[String: Any]] = []
        
        for note in notes {
            jsons.append(note.json)
        }
        
        for noteJson in jsons {
            XCTAssertTrue(noteJson.keys.contains("uuid"))
            XCTAssertTrue(noteJson.keys.contains("title"))
            XCTAssertTrue(noteJson.keys.contains("content"))
        }
        
        let colorProperty = "color"
        XCTAssertTrue(
            !jsons[0].keys.contains(colorProperty) &&
                !jsons[1].keys.contains(colorProperty) &&
                jsons[2].keys.contains(colorProperty) &&
                !jsons[3].keys.contains(colorProperty) &&
                jsons[4].keys.contains(colorProperty)
        )
        
        let erasureDateProperty = "erasureDate"
        XCTAssertTrue(
            !jsons[0].keys.contains(erasureDateProperty) &&
                !jsons[1].keys.contains(erasureDateProperty) &&
                !jsons[2].keys.contains(erasureDateProperty) &&
                jsons[3].keys.contains(erasureDateProperty) &&
                jsons[4].keys.contains(erasureDateProperty)
        )
        
        let newNotes = jsons.map { Note.parse($0)! }
        
        XCTAssertEqual(newNotes, notes)
    }

}
