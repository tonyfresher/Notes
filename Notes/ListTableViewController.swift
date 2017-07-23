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

class ListTableViewController: UITableViewController, UISplitViewControllerDelegate, NSFetchedResultsControllerDelegate {
    
    // MARK: - Properties
    
    private var notebook = Notebook()
    
    private let notebookUUID = "3392911E-D663-46AE-85A9-F1CAA702AFE0"
    
    private lazy var fetchedResultsController: NSFetchedResultsController<NotebookEntity> = {
        let fetchRequest: NSFetchRequest<NotebookEntity> = NotebookEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", self.notebookUUID)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: self.backgroundManagedObjectContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        return fetchedResultsController
    }()
    
    // MARK: Core Data usage
    
    private var coreDataManager: CoreDataManager! {
        didSet { backgroundManagedObjectContext = coreDataManager.createChildManagedObjectContext() }
    }
    
    private var backgroundManagedObjectContext: NSManagedObjectContext!
    
    private func fetchNotebook() {
        fetchedResultsController.managedObjectContext.perform {
            do {
                try self.fetchedResultsController.performFetch()
                guard let notebookEntitiy = self.fetchedResultsController.fetchedObjects?[0],
                    let notebook = notebookEntitiy.toNotebook() else {
                        fatalError("While loading data from database an error occured")
                }
                self.notebook = notebook
            } catch {
                // TODO: NEED HANDLING
                DDLogError("Error while fetching NotebookEntity: \(error.localizedDescription)")
            }
        }
    }
    
    // TODO: ADD "add", "update" and "remove"
    private func pushNotebook() {
        fetchedResultsController.managedObjectContext.perform {
            do {
                let context = self.fetchedResultsController.managedObjectContext
                
                let notebookEntity = try NotebookEntity.findOrCreateNotebookEntity(matching: self.notebook, in: context)
                
                let noteEntities = try self.notebook.map { (noteInfo) -> NoteEntity in
                    do {
                        return try NoteEntity.findOrCreateNoteEntity(matching: noteInfo, in: context)
                    } catch { throw error }
                }
                
                notebookEntity.notes = Set(noteEntities) as NSSet
            } catch {
                // TODO: NEED HANDLING
                DDLogError("Error while pushing NotebookEntity: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction private func saveNote(from segue: UIStoryboardSegue) {
        guard let detail = segue.source as? DetailViewController else { return }
        
        switch detail.state {
        case .creation:
            add(note: detail.note)
        case .editing:
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            update(note: detail.note, on: indexPath)
        default: break
        }
    }
    
    private func add(note: Note) {
        notebook.add(note: note)
        
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: notebook.size - 1, section: 0)], with: .fade)
        tableView.endUpdates()
        
        DDLogDebug("\(note) was saved to notebook")
    }
    
    private func update(note: Note, on indexPath: IndexPath) {
        notebook[indexPath.row] = note
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
        
        DDLogDebug("\(note) was updated")
    }
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        coreDataManager = (UIApplication.shared.delegate as! AppDelegate).coreDataManager
        
        self.splitViewController?.delegate = self
        self.fetchedResultsController.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Configuring UI
        splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.allVisible
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        fetchNotebook()
    }
    
    // MARK: Segues control
    
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
    
    // MARK: UITableViewDataSource implementation
    
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
            _ = notebook.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    // MARK: UISplitViewController stuff
    
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
