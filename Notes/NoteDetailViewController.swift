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
    
    @IBOutlet weak var autoErasureSwitch: UISwitch!
    @IBAction func switchAutoErasureDatePicker(_ sender: UISwitch) {
        autoErasureDatePicker.isHidden = sender.isOn ? false : true
    }
    
    @IBOutlet weak var autoErasureDatePicker: UIDatePicker!
    @IBAction func pickAutoErasureDate(_ sender: UIDatePicker, forEvent event: UIEvent) {
        note.erasureDate = sender.date
    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        if state != .blank {
            navigationController?.topViewController?.navigationItem.rightBarButtonItem =
                UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(NoteDetailViewController.saveNote(sender:)))
        }
        
        titleTextView?.delegate = self
        contentTextView?.delegate = self
        
        autoErasureDatePicker.minimumDate = Date()
        
        initFromNote()
    }
    
    private func initFromNote() {
        guard note != nil else {
            return
        }
        titleTextView.text = note.title
        contentTextView.text = note.content
        
        if let date = note.erasureDate {
            autoErasureSwitch.isOn = true
            autoErasureDatePicker.isHidden = false
            autoErasureDatePicker.setDate(date, animated: false)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == titleTextView {
            note.title = textView.text
        } else if textView == contentTextView {
            note.content = textView.text
        }
    }
    
    @objc private func saveNote(sender: UIBarButtonItem) {
        // MARK: NEED SOME KOSTYL
        DDLogInfo("\(note!) was saved to notebook")
        rootNavigationController?.popToRootViewController(animated: true)
    }
}

enum NotesTableViewControllerStates {
    case blank
    case creation
    case editing
}

extension UIViewController {
    
    var rootNavigationController: UINavigationController? {
        if navigationController == nil { return nil }
        
        var controller = navigationController!
        while controller.navigationController != nil {
            controller = controller.navigationController!
        }
        
        return controller
    }
}
