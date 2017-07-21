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
    
    // MARK: Properties
    
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
    
    // MARK: Injectable implementation
    
    func assertDependencies() {
        assert(note != nil)
    }
    
    // MARK: Lifecycle
    
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
    
    // MARK: UITextViewDelegate stuff
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == titleTextView {
            note.title = textView.text
        } else if textView == contentTextView {
            note.content = textView.text
        }
    }
    
    // MARK: Core Data usage
    
    @IBAction func saveNote(from segue: UIStoryboardSegue) {
        guard !note.isEmpty,
            let listViewController = segue.destination as? ListTableViewController else { return }
        
        switch state {
        case .creation:
            listViewController.add(note: note)
        case .editing:
            if let indexPath = listViewController.tableView.indexPathForSelectedRow {
                listViewController.update(note: note, on: indexPath)
            }
        default: break
        }
        
        presentingViewController?.dismiss(animated: true)
        //rootNavigationController?.popToRootViewController(animated: true)
        
        DDLogInfo("\(note!) was saved to notebook")
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
