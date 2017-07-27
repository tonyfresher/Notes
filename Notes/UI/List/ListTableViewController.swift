//
//  ListTableViewController.swift
//  Notes
//
//  Created by Anton Fresher on 12.07.17.
//  Copyright © 2017 Anton Fresher. All rights reserved.
//

import UIKit
import CocoaLumberjack
import CoreData

class ListTableViewController: UITableViewController {
    
    // PART: - Properties
    
    private var notebook = Notebook(uuid: "3392911E-D663-46AE-85A9-F1CAA702AFE0")
    
    // PART: - Core Data
    
    private var coreDataOperationsManager: CoreDataOperationsManager!
    
    // PART: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let coreDataManager = (UIApplication.shared.delegate as! AppDelegate).coreDataManager        
        coreDataOperationsManager = CoreDataOperationsManager(coreDataManager: coreDataManager)
        
        self.splitViewController?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: configuring UI
        splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.allVisible
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        prepareNotebook()
    }
    
    // PART: - UITableViewDataSource conformance
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? notebook.size : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier, for: indexPath)
        
        guard let noteCell = cell as? ListTableViewCell else { return cell }
        
        noteCell.note = notebook[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row < notebook.size
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // TODO: MAKE POPUP VIEW TO ASK IF THE USER SURE
            let note = notebook.remove(at: indexPath.row)
            
            dispatchNotebookModification(ui: UITableViewOperations.delete(from: tableView, at: [indexPath]),
                                         coreData: coreDataOperationsManager.remove(note, from: notebook),
                                         backend: DeleteOperation(note: note))
            
            DDLogDebug("\(note) was removed from notebook")
        }
    }
    
    // PART: - Segues handling
    
    static let createNoteSegueIdentifier = "Create Note"
    
    static let editNoteSegueIdentifier = "Edit Note"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination.contents as? DetailViewController {
            if segue.identifier == ListTableViewController.createNoteSegueIdentifier {
                detailViewController.state = .creation
                detailViewController.note = Note()
            } else if segue.identifier == ListTableViewController.editNoteSegueIdentifier,
                let noteIndex = tableView.indexPathForSelectedRow?.row {
                detailViewController.state = .editing
                detailViewController.note = notebook[noteIndex]
            }
        }
    }
    
    // MARK: unwind segue
    @IBAction private func saveNoteAfterEditing(from segue: UIStoryboardSegue) {
        guard let detail = segue.source as? DetailViewController, let note = detail.note else { return }
        
        switch detail.state {
            
        case .creation:
            notebook.add(note: note)
            
            let indexPaths = [IndexPath(row: notebook.size - 1, section: 0)]
            
            dispatchNotebookModification(ui: UITableViewOperations.insert(to: tableView, at: indexPaths),
                                         coreData: coreDataOperationsManager.add(note, to: notebook),
                                         backend: PostOperation(note: note))
            
            DDLogDebug("\(note) was saved to notebook")
            
        case .editing:
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            notebook[indexPath.row] = note
            
            dispatchNotebookModification(ui: UITableViewOperations.reload(in: tableView, at: [indexPath]),
                                         coreData: coreDataOperationsManager.createOrUpdate(note),
                                         backend: PutOperation(note: note))
            
            DDLogDebug("\(note) was updated")
            
        default:
            break
            
        }
    }
    
    // PART: - Main preparation
    
    private func prepareNotebook() {
        // MARK: update ui operation
        let updateUI = UITableViewOperations.reload(sections: [0], in: tableView) // QUESTION: async?

        // MARK: fetch operation
        let fetch = coreDataOperationsManager.fetch(notebook: notebook, success: { [weak self] fetched in
            guard let sself = self else { return }
            
            let erase = EraseOutdatedOperation(notebook: fetched, manager: sself.coreDataOperationsManager)
            erase.success = { [weak self] erased in
                self?.notebook = erased
            }
            
            updateUI.addDependency(erase)
            
            Dispatcher.dispatch(background: erase)
        })
        
        // MARK: get operation
        let get = GetAllOperation(success: { [weak self] notes in
            guard let sself = self else { return }
            
            for note in notes {
                // MARK: create or update operation
                let creation = sself.coreDataOperationsManager.createOrUpdate(note)
                // MARK: contains operation
                let check = sself.coreDataOperationsManager.contains(note, in: sself.notebook.uuid, success: { result in
                    if !result {
                        // MARK: add operation
                        let addition = sself.coreDataOperationsManager.add(note, to: sself.notebook)
                        
                        fetch.addDependency(addition)
                        Dispatcher.dispatch(coreData: addition)
                    }
                })
                
                check.addDependency(creation)
                fetch.addDependency(check)
                
                Dispatcher.dispatch(coreData: creation)
                Dispatcher.dispatch(coreData: check)
            }
        })
        
        updateUI.addDependency(fetch)
        fetch.addDependency(get)
        
        Dispatcher.dispatch(main: updateUI)
        Dispatcher.dispatch(coreData: fetch)
        Dispatcher.dispatch(backend: get)
    }
    
    // PART: - Special things
    
    private func dispatchNotebookModification(ui uiOperation: Operation,
                                              coreData coreDataOperation: Operation,
                                              backend backendOperation: Operation) {
        backendOperation.addDependency(coreDataOperation)
        uiOperation.addDependency(coreDataOperation)
        
        Dispatcher.dispatch(backend: backendOperation)
        Dispatcher.dispatch(coreData: coreDataOperation)
        Dispatcher.dispatch(main: uiOperation)
    }

}

extension ListTableViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        if primaryViewController.contents == self {
            if let noteDetailViewController =
                secondaryViewController.contents as? DetailViewController, noteDetailViewController.state == .blank {
                return true
            }
        }
        
        return false
    }
    
}

extension UIViewController {
    
    fileprivate var contents: UIViewController {
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController ?? self
        } else {
            return self
        }
    }
    
}
