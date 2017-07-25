//
//  CoreDataTests.swift
//  Notes
//
//  Created by Anton Fresher on 19.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import XCTest
import CoreData
@testable import Notes

class CoreDataTests: XCTestCase {
    
    private var manager = CoreDataManager(modelName: "Notes")
    
    private var context: NSManagedObjectContext!
    
    override func setUp() {
        context = manager.createChildManagedObjectContext()
    }
    
    func testNoteToNoteEntityConversion() {
        let notes = Variables.notes
        
        context.perform { [weak self] in
            guard let sself = self else { return }
            
            let noteEntities = notes.map { try! NoteEntity.findOrCreateNoteEntity(matching: $0, in: sself.context) }
            
            let notesFromNoteEntities = noteEntities.map { $0.toNote()! }
            
            XCTAssertEqual(notes, notesFromNoteEntities)
        }
    }
    
    func testNotebookToNotebookEntityConversion() {
        let notebook = Variables.notebook
        
        context.perform { [weak self] in
            guard let sself = self else { return }
            
            let notebookEntity = try! NotebookEntity.findOrCreateNotebookEntity(matching: notebook, in: sself.context)
            
            let notebookFromNotebookEntityOptional = notebookEntity.toNotebook()
            
            guard let notebookFromNotebookEntity = notebookFromNotebookEntityOptional else {
                XCTFail()
                return
            }
            
            for note in notebook { XCTAssertTrue(notebookFromNotebookEntity.contains(note)) }
            for note in notebookFromNotebookEntity { XCTAssertTrue(notebook.contains(note)) }
        }
    }

}
