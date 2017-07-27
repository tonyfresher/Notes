//
//  DetailViewController.swift
//  Notes
//
//  Created by Anton Fresher on 12.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import UIKit
import CocoaLumberjack
import CoreData

class DetailViewController: UIViewController, UITextViewDelegate, Injectable {
    
    /// States of this controller
    ///
    /// - blank: empty view, no action is needed
    /// - creation: creating new note
    /// - editing: editing existing note
    enum State {
        case blank
        case creation
        case editing
    }
    
    // PART: - UI
    
    @IBAction func cancel(_ sender: Any) {
        rootNavigationController?.popToRootViewController(animated: true)
    }
    
    @IBOutlet weak var titleTextView: UITextView!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var autoErasureSwitch: UISwitch!
    @IBAction func switchAutoErasureDatePicker(_ uiSwitch: UISwitch) {
        autoErasureDatePicker.isHidden = uiSwitch.isOn ? false : true
        if !uiSwitch.isOn {
            noteErasureDate = nil
        }
    }
    
    @IBOutlet weak var autoErasureDatePicker: UIDatePicker!
    @IBAction func pickAutoErasureDate(_ sender: UIDatePicker, forEvent event: UIEvent) {
        noteErasureDate = sender.date
    }
    
    // MARK: - Properties
    
    var state: State = .blank
    
    var note: Note! {
        didSet {
            noteTitle = note.title
            noteContent = note.content
            noteColor = note.color
            noteErasureDate = note.erasureDate
        }
    }
    
    var noteTitle: String!
    var noteContent: String!
    var noteColor: UIColor!
    var noteErasureDate: Date?
    
    private func initUI() {
        guard note != nil else { return }
        
        switch state {
        case .creation:
            titleTextView.text = "Title"
            contentTextView.text = "Content"
        case .editing:
            titleTextView.text = note.title
            contentTextView.text = note.content
        default: break
        }
        
        if let date = note.erasureDate {
            autoErasureSwitch.isOn = true
            autoErasureDatePicker.isHidden = false
            autoErasureDatePicker.setDate(date, animated: false)
        }
    }
    
    private func saveNote() {
        let builded = NoteBuilder(from: note)
            .set(title: titleTextView.text)
            .set(content: contentTextView.text)
            .set(color: noteColor)
            .set(erasureDate: noteErasureDate)
            .build()
        
        guard let buildedNote = builded else { return }
        note = buildedNote
    }
    
    // PART: - Injectable implementation
    
    func assertDependencies() {
        assert(note != nil)
    }
    
    // PART: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assertDependencies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if state == .blank {
            navigationController?.topViewController?.navigationItem.rightBarButtonItem = nil
            navigationController?.topViewController?.navigationItem.leftBarButtonItem = nil
        }
        
        titleTextView?.delegate = self
        contentTextView?.delegate = self
        
        autoErasureDatePicker.minimumDate = Date()
        
        initUI()
    }
    
    // PART: - Segues handling
    
    private static let saveNoteSegueIdentifier = "Save Note"
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        saveNote()
        
        if identifier == DetailViewController.saveNoteSegueIdentifier &&
            note.isEmpty {
            // TODO: SHOW POPUP
            return false
        }
        return super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
    }
    
    // PART: - UITextViewDelegate stuff
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == titleTextView {
            noteTitle = textView.text
        } else if textView == contentTextView {
            noteContent = textView.text
        }
    }

}

extension UIViewController {
    
    fileprivate var rootNavigationController: UINavigationController? {
        if navigationController == nil { return nil }
        
        var controller = navigationController!
        while controller.navigationController != nil {
            controller = controller.navigationController!
        }
        
        return controller
    }

}
