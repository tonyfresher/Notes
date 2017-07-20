//
//  DetailViewController.swift
//  Notes
//
//  Created by Anton Fresher on 12.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import UIKit
import CocoaLumberjack

class DetailViewController: UIViewController, UITextViewDelegate {
    
    // MARK: UI
    
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
    
    var state: State = .blank
    
    var note: Note! {
        didSet {
            if note.isEmpty {
                state = .creation
            } else {
                state = .editing
            }
        }
    }
    
    private func initFromNote() {
        guard note != nil else {
            return
        }
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        if state != .blank {
            navigationController?.topViewController?.navigationItem.rightBarButtonItem =
                UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(DetailViewController.saveNote(sender:)))
        }
        
        titleTextView?.delegate = self
        contentTextView?.delegate = self
        
        autoErasureDatePicker.minimumDate = Date()
        
        initFromNote()
    }
    
    // MARK: UITextViewDelegate stuff
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == titleTextView {
            note.title = textView.text
        } else if textView == contentTextView {
            note.content = textView.text
        }
    }
    
    // MARK: Core Data usage
    
    var coreDataManager: CoreDataManager!
    
    @objc private func saveNote(sender: UIBarButtonItem) {
        // MARK: NEED SOME KOSTYL
        DDLogInfo("\(note!) was saved to notebook")
        rootNavigationController?.popToRootViewController(animated: true)
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
