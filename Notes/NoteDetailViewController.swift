//
//  NoteDetailViewController.swift
//  Notes
//
//  Created by Anton Fresher on 12.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import UIKit
import CocoaLumberjack

class NoteDetailViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var titleTextView: UITextView!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    var state: NotesTableViewControllerStates = .blank
    
    var note: Note! {
        didSet {
            if note.isEmpty {
                state = .creation
            } else {
                state = .editing
            }
        }
    }
    
    private func updateUI() {
        guard note != nil else {
            return
        }
        titleTextView.text = note.title
        contentTextView.text = note.content
        // And so on
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if state != .blank {
            navigationController?.topViewController?.navigationItem.rightBarButtonItem =
                UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(NoteDetailViewController.saveNote(sender:)))
        }
        updateUI()
    }
    
    @objc private func saveNote(sender: UIBarButtonItem) {
        DDLogInfo("\(note) was saved to notebook")
        navigationController?.navigationController?.popToRootViewController(animated: true)
    }
}

enum NotesTableViewControllerStates {
    case blank
    case creation
    case editing
}
